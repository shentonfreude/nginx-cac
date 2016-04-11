==================
 README nginx-cac
==================

Code taken from
http://geocentlabs.com/configure-nginx-for-ssl-with-dod-cac-authentication-on-centos-6-3/
and Dockerized.  Since I couldn't supply passwords during cert
creation, I don't do that on the docker box but once locally then save
the resulting files and have docker build install them to the correct
location. It builds and runs fine.

When card inserted, dongle blinks indicating the card is not active.

When I connect with Safari, it requests selection of a certificate, I
pick my NASA one. It then asks for my badge password which I
use. Nginx reports:

  400 Bad Request
  The SSL certificate error

The card reader light now stays green on the card, indicating it's active.

I'm using a self-signed cert. Is there not a way for me to read the
identity off the card and grab the user identity, then compare with
some local file of DNs?

On Chrome, after activating the card once, I remove it, then reinsert,
it blinks indicating it's deactivated. I don't know how to force it to
reactivate. Even a private browser doesn't force this.

I don't see any traffic in the logs about the failed connection.
