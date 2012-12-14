# Twitmore

Simple wrapper for [Twtmore](http://twtmore.com)

## Requirement

- [Twtmore developer registration](http://twtmore.com/api)
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- ARC

## Usage

	Twtmore *twt = [[Twtmore alloc] initWithAPIKey:@"YOUR_API_KEY"]];
	[twt shorten:@"YOUR_LONG_TWEET"
        username:@"YOUR_TWITTER_SCREENNAME"
         success:(void(^)(id JSON)) {
         
         	NSString *short_content = [JSON objectForKey:@"short_content"];
         	NSLog(@"Short content : %@", short_content);
         
         } error:(void(^)(NSError *error)) {
         
         	// Do something with error
         	
         }];

## License

Available under the MIT license.