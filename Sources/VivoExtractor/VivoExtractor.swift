import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public class VivoExtractor {
    
    /// decodes direct video url from encoded source string from vivo page
    /// - parameter encodedSource: encoded url from vivo
    /// - returns: video url when found
    public class func extract(fromEncodedSource encodedSource: String) -> URL? {
        var decoded = ""
        for c in encodedSource.removingPercentEncoding ?? "" {
            var j = Int(c.asciiValue ?? 0)
            j += 47
            if j > 126 {
                j -= 94
            }
            decoded.append(Character(UnicodeScalar(j)!))
        }
        return URL(string: decoded)
    }
    
    
    /// extracts direct video url from raw html of vivo page
    /// - parameter html: HTML of video page on vivo.sx
    /// - returns: video url when found
    public class func extract(fromHTML html: String) -> URL? {
        
        let pattern = #"InitializeStream\s*\(\{[\s\S]*(source\:[\s]\')(?<url>[\s\S\:]*?)(\',\s*)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        guard let match = regex?.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count)) else { return nil }
        
        let matchRange = match.range(at: 2) //match.range(withName: "url")
        guard let range = Range(matchRange, in: html) else { return nil }
        
        let encodedSource = String(html[range])
        
        return extract(fromEncodedSource: encodedSource)
    }
    
    
    /// extracts direct video url from standard vivo url
    /// - parameter url: vivo url (e.g.: https://vivo.sx/b36ee9e324)
    /// - parameter completion: called when result is found. returns video url
    public class func extract(fromURL url: URL, completion: @escaping (URL?) -> Void) {
        
        #if os(Linux)
        
        DispatchQueue.global(qos: .background).async {
            guard let htmlContent = try? String(contentsOf: url, encoding: .utf8) else {
                completion(nil)
                return
            }
            
            completion(extract(fromEncodedSource: htmlContent))
        }
        
        #else
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let htmlContent = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            
            completion(extract(fromHTML: htmlContent))
            
        }.resume()
        
        #endif
    }
    
}
