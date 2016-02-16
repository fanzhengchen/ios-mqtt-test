//
//  ViewController.m
//  MqttTest
//
//  Created by fanzhengchen on 2/15/16.
//  Copyright © 2016 fanzhengchen. All rights reserved.
//

#import "ViewController.h"
#import "MQTTKit.h"


@interface ViewController (){
    MQTTClient *client;
    NSString *clientID;
    NSString *host;
    NSInteger qos;
    NSString *topic;
}

@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    host = @"localhost";
    qos = 1;
    topic = @"mqtt";
    clientID = @"fzc";
    client = [[MQTTClient alloc] initWithClientId:clientID];
    [_publishButton setBackgroundColor:[UIColor redColor]];
    [_publishButton setTitle:@"PUBLISH" forState:UIControlStateNormal];
    [_publishButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchDown];
    
    [_subscribeButton setBackgroundColor:[UIColor greenColor]];
    [_subscribeButton setTitle:@"SUBSCRIBE" forState:UIControlStateNormal];
    [_subscribeButton addTarget:self action:@selector(subscribe)
               forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)publish{
    NSLog(@"FUCK");
    
   
    [client connectToHost:host completionHandler:^(NSUInteger code){
        [client publishString:@"Hello MQTT"
                      toTopic:topic
                      withQos:1
                       retain:YES
            completionHandler:^(int mid){
                NSLog(@"Message has been delivered");
            }];
    }];
}

- (void)subscribe{

    NSLog(@"subscribe");
    [client setMessageHandler:^(MQTTMessage *message){
        NSString *text = [message payloadString];
        NSLog(@"receive message %@", text);
        //[weakSelf.contentLabel setText:text];
    }];
    [client subscribe:topic withCompletionHandler:nil];
    
}

- (void)disconnect{
    [client disconnectWithCompletionHandler:^(NSUInteger code){
        NSLog(@"MQTT is disconnected");
    }];
}
@end
