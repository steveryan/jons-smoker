Web/Mobile automation of a "dumb" electric smoker. 

![IMG_0964](https://github.com/user-attachments/assets/44492c67-3d28-4024-bda9-6c6f72b16978)


This is a hobby project though once it was fully operational, I gifted it to my cousin, Jon, to control his smoker.

This repo contains rails code that runs the control webapp.
It's a very minimal rails app that uses Hotwire and Chartkick to provide real time control and visibility into the smoker's status.

The smoker itself is controlled by a raspberry pi zero 2W running a custom firware that I wrote using the Nerves framework for embedded Elixir development. That firmware code can be found [here](GitHub.com/steveryan/jons_smoker)

The communication between the webapp and the smoker is a simple hosted Redis DB. Essentially using the Redis DB as simple message bus. This was dead simple to implement, and allows for multiple instances of the webapp to be kept in sync with the smokers current status. It also allows for fault tolerance. If the smoker temporarily loses internet when a new temperature is set, it simply picks it up the next time it checks Redis.
