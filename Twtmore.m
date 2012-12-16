// Twtmore.m
//
// Copyright (c) 2012 Yunseok Kim (http://mywizz.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Twtmore.h"
#import "AFNetworking.h"

NSString * const kTwtmoreBaseURL = @"http://api.twtmore.com";
NSString * const kTwtmoreErrorDomain = @"com.twtmore.Twtmore";

@implementation Twtmore

// ---------------------------------------------------------------------
#pragma mark -

- (id)initWithAPIKey:(NSString *)theKey
{
	self = [super init];
	if (self)
	{
		self.apiKey = theKey;
	}
	return self;
}

// ---------------------------------------------------------------------
#pragma mark -

- (void)shorten:(NSString *)tweet
       username:(NSString *)username
        success:(void(^)(id JSON))successBlock
          error:(void(^)(NSError *error))errorBlock
{
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                           tweet, @"tweet",
                           username, @"user",
                           self.apiKey, @"apikey",
                           nil];
	
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kTwtmoreBaseURL]];
	NSURLRequest *request = [client requestWithMethod:@"POST" path:@"/v3/shorten" parameters:params];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if (operation.response.statusCode == 200)
		{
			NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
			NSError *jsonError;
			NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
			if (jsonError != nil)
			{
				errorBlock(jsonError);
			}
			else
			{
				successBlock(jsonInfo);
			}
		}
		else
		{
			NSError *error = [NSError errorWithDomain:kTwtmoreErrorDomain code:0 userInfo:[NSDictionary dictionaryWithObject:operation.responseString forKey:NSLocalizedDescriptionKey]];
			errorBlock(error);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		errorBlock(error);
		
	}];
		
	[operation start];
}

- (void)callback:(NSString *)callbackKey
        statusID:(NSInteger)statusID
         handler:(void(^)(BOOL))handler
{
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.apiKey, @"apikey",
                               callbackKey, @"key",
                               [NSString stringWithFormat:@"%lu", statusID], @"status_id",
                               nil];
	
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kTwtmoreBaseURL]];
	NSURLRequest *request = [client requestWithMethod:@"POST" path:@"/v3/callback" parameters:parameters];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		handler(operation.response.statusCode == 200);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		handler(NO);
		
	}];
	
	[operation start];
}

@end