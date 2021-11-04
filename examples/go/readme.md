# reference for installation of golang
install golang using: https://computingforgeeks.com/how-to-install-go-golang-on-fedora/

# install
```bash
$ sudo dnf -y update
$ sudo dnf -y install go
$ go version

# test the install
$ mkdir -p ~/dev/go/src/helloworld && cd ~/dev/go/src/helloworld
$ cat>helloworld.go<<EOF
package main
import "fmt"
func main() {
	fmt.Printf("hello, world\n")
}
EOF

$ go mod init helloworld
$ go build

# will generate an executable helloworld
$ ls
$ ./helloworld

# to clean
$ go clean -i

# modify ~/.bashrc to add go binary directory to PATH and add a GOPATH
export PATH="$PATH:~/dev/go/bin/"
export GOPATH="~/dev/go"
