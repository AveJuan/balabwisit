# balabwisit
This is a module that utilizes the built in command of Linux named "SCRIPT".

Main purpose of this is to be able to find an alternative to Balabit, a tool that could record the session of every user that access the server.

This is a simple module and to use it is very easy.


###

To use this module you must ensure that you do the following below:

1.) Create an ssh-key, you can easily do this through putty gen.. Without this you won't be able to authenticate to the server this will ensure that
we know who uses the certain account.

2.) Apply those ssh key under ("./ssh/authorize_key")

3.) Once done, you can add your node on ("manifest/site.pp") and call the balabwisit module.

4.) Please do make sure that the user you want to monitor is added to BALABWISIT group.

5.) Please do note that when you do this. You will also be requested to provide the key when you perform FTP. But, the session will not be recorded.
###

