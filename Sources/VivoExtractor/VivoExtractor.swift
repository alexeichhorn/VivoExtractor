import Foundation

public class VivoExtractor {
    
    public class func extract(fromHTML html: String) -> URL? {
        return nil
    }
    
    public class func extract(fromURL url: URL, completion: @escaping (URL?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let htmlContent = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            
            completion(extract(fromHTML: htmlContent))
            
        }.resume()
        
    }
    
}
