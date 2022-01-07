---
label: Log4J Shell Attack Mitigation with Kontain
icon: /images/k8s.png
order: 900
---

## Blog entry
Here is a [blog entry](https://medium.com/kontain/log4j-shell-attack-mitigation-with-kontain-containers-e226ca2a3172) discussing in detail the Log4jShell attack with and without Kontain based containers.

## Spring Boot Application packaged and run as a Docker Container
* Video showing how a Spring Boot Application gets compromised with a reverse shell when packaged and run as a Docker Container, when attacked using Log4JShell attack
* Attacker can execute shell commands in the container
[![asciicast](https://asciinema.org/a/458347.svg)](https://asciinema.org/a/458347?speed=1.3&t=4)

## Spring Boot Application packaged and run as a Kontain based Container
* Video showing how a Spring Boot Application when packaged and run as a Kontain based Container, and when attacked using Log4JShell, and even if compromised due to Log4J, the attacker cannot do anything
[![asciicast](https://asciinema.org/a/458372.svg)](https://asciinema.org/a/458372?speed=1.4)
