# CLMNetworking

## Overview

CLMNetworking は OAuth 2.0 を利用した REST API に対しての処理を簡潔にするためのライブラリです。

### ステータスコード

200、201、204、400、401、403、404、409, 410, 422, 500, 503 の 12 種類のステータスコードを利用します。GET、PUT または PATCH リクエストに対しては 200 を、POST リクエストに対しては 201 を、DELETE リクエストに対しては 204 を返します。但し、エラーが起きた場合にはその他のステータスコードの中から適切なものを返します。

### データ形式

APIとのデータの送受信にはJSONを利用します。JSONをリクエストボディに含める場合、リクエストのContent-Typeヘッダにapplication/jsonを指定してください。但し、GETリクエストにバラメータを含める場合にはURIクエリを利用します。また、DELETEリクエストに対してはレスポンスボディが返却されません。日時を表現する場合には、ISO 8601形式（ミリ秒を含む）の文字列を利用します。尚、レスポンスボディがリソースの一覧を表す場合は Array 型、単一のリソースを表す場合は Object 型 のレスポンスオブジェクトを返却します。

### ページネーション

一部の配列を返すAPIでは、全ての要素を一度に返すようにはなっておらず、代わりにページを指定できるようになっています。これらのAPIには、1から始まるページ番号を表すpageパラメータと、1ページあたりに含まれる要素数を表すper_pageパラメータを指定することができます。pageの初期値は1、pageの最大値は100に設定されています。また、per_pageの初期値は20、per_pageの最大値は100に設定されています。
ページを指定できるAPIでは、Linkヘッダ を含んだレスポンスを返します。Linkヘッダには、最初のページと最後のページへのリンクに加え、存在する場合には次のページと前のページへのリンクが含まれます。個々のリンクにはそれぞれ、first、last、next、prevという値を含んだrel属性が紐付けられます。

```
Link: <http://api.example.com/v1/posts?page=1&per_page=20">; rel="first"; page="1",
      <http://api.example.com/v1/posts?page=1&per_page=20>; rel="prev"; page="1",
      <http://api.example.com/v1/posts?page=3&per_page=20>; rel="next"; page="3",
      <http://api.example.com/v1/posts?page=6&per_page=20>; rel="last"; page="6"
```

また、ページを指定できるAPIでは、要素の合計数が X-List-Totalcount レスポンスヘッダに含まれます。

```
X-List-Totalcount: 6
```

### フィールド指定

GETリクエストのパラメータにおいて、返却すべきリソースのフィールドを指定できるようになっています。これらの API には、fields パラメータに返却すべきフィールドを「,（カンマ）」区切りで指定することができます。

```
http://api.example.com/v1/posts?fields=id,title,body
```

## Requirements

iOS 7+

## Installation

CLMNetworking is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "CLMNetworking", git: 'git@github.com:hirai-yuki/CLMNetworking.git'
>
## Usage

### REST API Coordinator

#### Import

```
#import <CLMNetworking/CLMRESTAPICoordinator.h>
```

#### Generate coordinator

```
id<CLMOAuth2CredentialProvider> credentialProvider; // Coordinator needs credentialProvider

CLMRESTAPICoordinator *coordinator = [CLMRESTAPICoordinator coordinatorWithBaseURL:[NSURL URLWithString:@"http://api.classmethod.jp/v1/"]
                                                                   OAuth2TokenEndpoint:@"oauth/token"
                                                                              clientID:@"client ID"
                                                                                secret:@"secret"
                                                                    credentialProvider:credentialProvider];
```

#### Authenticate

```
[coordinator.authenticationAgent authenticateUsingOAuthWithUsername:@"username" password:@"password" scope:@"public"];
```

#### REST API Client

```
CLMRESTAPIClient *client = [coordinator RESTAPIClientWithEndpoint:@"posts"];
[client getResourcesWithParameters:nil needsAuthentication:YES]  continueWithSuccessBlock:^id(BFTask *task) {
	//  Process for success...
	return nil;
}];
```


## Author

hirai.yuki, hirai.yuki@classmethod.jp

## License

CLMNetworking is available under the MIT license. See the LICENSE file for more info.
