//
//  AuthResponse.swift
//  spotify
//
//  Created by Naman Jain on 18/05/21.
//

import Foundation

/*
 {
     "access_token" = "BQAfgYR8ftTatwYKDeaJ5lVYWDFyf2VrQ_fhKAWm2lEsTY4uQcma5KIUAfxXKch-MxCxra3GU6PBSIun5YOo5ivfs2kPYvdsMI9k0ZUy-b-zW_LtdKdC1CYFPpFpqtwUHvvlHETS8LAg8UVB90nFTUBUmJ7KQ-00AYxojBwjrNGj43A";
     "expires_in" = 3600;
     "refresh_token" = "AQAI-FsR_NI3wt7rOGdGBrHWQP6BD7QisjMnAMyao41H1dJ8fFdXOnQFr43FZGbyN2Cd5q94qwOlGv_AGHNzgKF5iYy_4ouWVZvzWZSQ7Iofle82tN3W4c0ZuccV5S0cnxQ";
     scope = "user-read-private";
     "token_type" = Bearer;
 }
 */

struct AuthResponse: Codable{
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
