### What is this?

This project was bootstrapped with [Create React App](https://github.com/facebookincubator/create-react-app).

It also utilizes CircleCI as a build solution, using a custom docker image that extends CircleCI's `circleci/node:chakracore` image to add the awscli for use in deploying the final build files to S3 as a static website.

### To Use

Just update `<*bucket-name*>` in the CircleCI config file to have the correct bucket name from your aws configuration:

```
      - run:
          name: Deploy build folder to S3
          command: ~/.local/bin/aws s3 sync build s3://<*bucket-name*>/ --delete --exclude "index.html"
      - run:
          name: Copy index.html and add metadata for cache control
          command: ~/.local/bin/aws s3 cp build/index.html s3://<*bucket-name*>/index.html --cache-control=no-cache
```

Then make sure that CircleCI is set up with AWS credentials from an IAM user in your AWS account and make sure it has the correct permissions to run these S3 commands, which would look something like this right now (again, replacing `<*bucket-name*>` with your bucket name):

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingBucketObjects",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:HeadBucket",
                "s3:ListObjects"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowModificationOfBucketObjects",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObjectTagging",
                "s3:PutObject",
                "s3:DeleteObjectVersion",
                "s3:PutObjectVersionTagging",
                "s3:PutObjectTagging",
                "s3:DeleteObjectVersionTagging",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::<*bucket-name*>/",
                "arn:aws:s3:::<*bucket-name*>/*"
            ]
        }
    ]
}
```

### Other info

I removed the react app service worker, because it caused issues with caching that I didn't want to deal with at the time.
