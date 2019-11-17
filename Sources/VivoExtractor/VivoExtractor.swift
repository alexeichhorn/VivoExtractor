import Foundation

public class VivoExtractor {
    
    public class func extract(fromEncodedSource encodedSource: String) -> URL? {
        return nil
    }
    
    public class func extract(fromHTML html: String) -> URL? {
        
        let pattern = #"InitializeStream\s*\(\{[\s\S]*(source\:[\s]\')(?P<url>[\s\S\:]+?)(\',\s*)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        guard let match = regex?.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count)) else { return nil }
        
        let matchRange = match.range(at: 2) //match.range(withName: "url")
        guard let range = Range(matchRange, in: html) else { return nil }
        
        let encodedSource = String(html[range])
        
        return extract(fromEncodedSource: encodedSource)
    }
    
    public class func extract(fromURL url: URL, completion: @escaping (URL?) -> Void) {
        
        #if os(Linux)
        
        completion(nil)
        
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
