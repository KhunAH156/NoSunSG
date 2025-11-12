# Ever sat on the wrong side of the Singapore MRT and got roasted by the sun the whole ride? ☀️🚆

Well…I did and it gave me the idea for my latest side project.

Last week, while heading home from school, I found myself debating the most random (but I bet pretty relatable) question:
Which side of the MRT should I sit on to avoid the sun?

You can probably guess where this is going…
I chose the wrong side.
And spent the entire ride with the sun shining right on my back. 💀

That’s when the idea hit me:

“Why isn’t there an app that tells you which side to sit on to avoid the sun?”

After a quick search and finding none, I remembered…
I’m a computer engineering student who knows a thing or two about coding.
So the moment I got home, I opened my laptop and started to get my hands dirty!


🛠️ The Build

At first, I wanted to make it a mobile app, but since I wanted something that worked on any device, I went with Flutter, which also supports Progressive Web Apps (PWA).

At first glance, it looks simple….just four inputs….but under the hood, it’s doing a lot more than a few nested if-else statements and is more of a math challenge…

Here’s what it actually does:
 - Uses the geographical coordinates of each MRT station
 - Calculates the bearing (direction) between stations to map the line’s orientation
 - Combines that with the sun’s position at different times of day
 - Then predicts which side of the train (left or right) will have more shade

After very “technical” tests, during my own commutes, squinting out through the windows, It is estimated to be around 80 % accurate (take it with a grain of salt 😃), which is more than enough to save me from the afternoon glare.

When I finally used it for my next ride, I thought to myself:

“If it’s useful to me, someone else probably needs it too.”

And that’s why I built NoSun SG…. a small, simple tool born from everyday inconvenience.
