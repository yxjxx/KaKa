#JSON 通信规范

************

###login

http://www.linzerlee.cn:8080/kakaweb/home/login/

client post

```
{
    @"mobile": @"13125197350",
    @"password": [@"123456" MD5Digest]
}
```

server response

```
{
    data = "<null>";
    errcode = 0;
    errmsg = "service success";
    "ext_data" =     {
        username = KaKa;
    };
}
```

###register

http://www.linzerlee.cn:8080/kakaweb/home/register/

client post

```
{
    @"username": @"13125197350",
    @"password": [@"123456" MD5Digest],
    @"mobile":  @"13125197350"
}
```

server response

```
{
    data = "<null>";
    errcode = 0;
    errmsg = "service success";
    "ext_data" = "<null>";
}
```
###get_video

@"http://www.linzerlee.cn:8080/kakaweb/home/get_video_info/"

client get

```
params[@"order"] = @"1";  //1 || 2
params[@"page"] = @"0-2"; //2 video of page 0
```

server response

```
{
    data =     (
                {
            favorite = 0;
            hint = 0;
            kid = 1;
            path = "20160225/1915aa3c622c58b83dbd9f98433a864e.mp4";
            snapshot = "http://www.linzerlee.cn/kakadata/snapshot/20160225/1915aa3c622c58b83dbd9f98433a864e.jpg";
            timelen = 0;
            timestamp = 1456384591;
            vid = 2;
            vname = "\U5bab\U5fc3\U8ba1";
            zan = 0;
        },
                {
            favorite = 0;
            hint = 0;
            kid = 1;
            path = "20160225/60ac9aa418c1a06d2be987627c5209ef.mp4";
            snapshot = "http://www.linzerlee.cn/kakadata/snapshot/20160225/60ac9aa418c1a06d2be987627c5209ef.jpg";
            timelen = 0;
            timestamp = 1456384591;
            vid = 3;
            vname = "\U95fa\U871c";
            zan = 0;
        }
    );
    errcode = 0;
    errmsg = "service success";
    "ext_data" = "<null>";
}
```

*******


###get_audio

http://www.linzerlee.cn:8080/kakaweb/mobile/get_audio/?page=0-2

http://www.linzerlee.cn:8080/kakaweb/mobile/get_audio/

client get

```
params[@"page"] = @"0-2"; //2 audio of page 0
```

server response

```
 {
    data =     (
                {
            cid = 1;
            cname = "\U539f\U521b\U7cbe\U9009";
            mid = 48;
            path = "http://www.linzerlee.cn/kakadata/audio/20160225/a4d0962d870154ed9ceb2fe9f0de4471.mp3";
            subject = "\U5c0f\U5973\U5b69";
            timestamp = 1456385554;
        },
                {
            cid = 1;
            cname = "\U539f\U521b\U7cbe\U9009";
            mid = 47;
            path = "http://www.linzerlee.cn/kakadata/audio/20160225/a327b5456b9c881ad0eccf5d490c65a0.mp3";
            subject = "\U4e94\U6708\U5929-\U5014\U5f3a";
            timestamp = 1456385543;
        }
    );
    errcode = 0;
    errmsg = "service success";
    "ext_data" = "<null>";
}
```

**********

###get_personal_video_list


client get

```
http://www.linzerlee.cn:8080/kakaweb/home/get_video_info/?kid=1&order=1&page=0-2
```

```
params[@"kid"] = @"1";
params[@"order"] = @"1";  //1 || 2
params[@"page"] = @"0-2"; //2 video of page 0
```

server response

```
  {
    data =     (
                {
            favorite = 14;
            hint = 89;
            kid = 1;
            path = "http://www.linzerlee.cn/kakadata/video/20160225/1915aa3c622c58b83dbd9f98433a864e.mp4";
            snapshot = "http://www.linzerlee.cn/kakadata/snapshot/20160225/1915aa3c622c58b83dbd9f98433a864e.jpg";
            timelen = 0;
            timestamp = 1456384591;
            vid = 2;
            vname = "\U5bab\U5fc3\U8ba1";
            zan = 23;
        },
                {
            favorite = 9;
            hint = 56;
            kid = 1;
            path = "http://www.linzerlee.cn/kakadata/video/20160225/60ac9aa418c1a06d2be987627c5209ef.mp4";
            snapshot = "http://www.linzerlee.cn/kakadata/snapshot/20160225/60ac9aa418c1a06d2be987627c5209ef.jpg";
            timelen = 0;
            timestamp = 1456384591;
            vid = 3;
            vname = "\U95fa\U871c";
            zan = 35;
        }
    );
    errcode = 0;
    errmsg = "service success";
    "ext_data" = "<null>";
}

```

*********

###upload_video

http://www.linzerlee.cn:8080/kakaweb/upload/video/

client post

```
{
    @"vname": @"",
    @"aid": @"",
    @"timelen": @"",

//视频和快照在 body 里面上传
    body.path body.snapshot
}
```

upload success server response

```
Upload Success: {
    data =     {
        vid = 56;
    };
    errcode = 0;
    errmsg = "service success";
    "ext_data" = "<null>";
}
```

###get_userinfo

client get

http://www.linzerlee.cn:8080/kakaweb/home/get_userinfo/?kid=1&sign=fans


server response

```
{
    "errcode": 0,
    "errmsg": "service success",
    "data": [{
        "city": "",
        "kid": 10,
        "video": 2,
        "portrait": "http://www.linzerlee.cn/kakadata/portrait/20160309/9.jpg",
        "username": "咔咔咔不咔",
        "fans": 0
    }, {
        "city": "",
        "kid": 11,
        "video": 2,
        "portrait": "http://www.linzerlee.cn/kakadata/portrait/20160309/10.jpg",
        "username": "可可可爱莹",
        "fans": 0
    }],
    "ext_data": null
}
```

******

client get

http://www.linzerlee.cn:8080/kakaweb/home/get_userinfo/?kid=1

server response

```
{
    "errcode": 0,
    "errmsg": "service success",
    "data": {
        "city": "",
        "kid": 1,
        "video": 11,
        "portrait": "http://www.linzerlee.cn/kakadata/portrait/20160309/12.jpg",
        "username": "KaKa",
        "fans": 5
    },
    "ext_data": null
}
```

*****

client get

http://www.linzerlee.cn:8080/kakaweb/home/get_userinfo/?kid=1&sign=attentions

server response

```

```
