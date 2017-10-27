using System;
using System.Linq;
using System.Threading;
using System.Net;  
using System.Net.Sockets;  
using Emitter;
using Newtonsoft.Json;
using Tweetinvi;
using Tweetinvi.Models;

namespace twitter_streamer
{
    class Program
    {

        static void Main(string[] args)
        {
                Console.WriteLine("Starting..."); 
            
            // Creating a connection to emitter.io service.
            //var emitter    = new Emitter.Connection();
            //var channelKey = "IsQ7z18uGEFpjOJpt4K6ij49klT3PGzu";
            //var topic = "tweet-stream";
            //emitter.Connect();
            // or
            //var emitter = Connection.Establish();

            // Set up your credentials (https://apps.twitter.com)

            Auth.SetUserCredentials(
                Environment.GetEnvironmentVariable("CONSUMER_KEY"),
                Environment.GetEnvironmentVariable("CONSUMER_SECRET"),
                Environment.GetEnvironmentVariable("ACCESS_TOKEN"),
                Environment.GetEnvironmentVariable("ACCESS_TOKEN_SECRET")
                );

            // Setup a rate limiter
            var limiter = new Throttle(1, TimeSpan.FromMilliseconds(350));

            // Using the sample stream
            var stream = Stream.CreateFilteredStream();
            var centerOfSoweto = new Location(new Coordinates(-26,27), new Coordinates(27,85));
            stream.AddLocation(centerOfSoweto);
            stream.AddTweetLanguageFilter(LanguageFilter.English);
            stream.FilterLevel = Tweetinvi.Streaming.Parameters.StreamFilterLevel.Low;
            stream.MatchingTweetReceived += (sender, t) =>
            {
                // Skip retweets
                if (t.Tweet.IsRetweet)
                    return;

                var ct = new CancellationToken();
                limiter.Enqueue(() =>
                {
                    // Publish the tweet to the broker
                    /*emitter.Publish(
                        channelKey,
                        topic,
                        JsonConvert.SerializeObject(t.Tweet)
                        );*/
                       Console.WriteLine(t.Tweet.CreatedBy+"\n"+t.Tweet.Text); 
                }, ct);
            };

            // Start
            stream.StartStreamMatchingAllConditions();
        }
    }
}
