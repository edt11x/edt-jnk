
package main
import "os"
import "strings"
import "fmt"

func main() {
    result := strings.Split(os.Getenv("PATH"), ";")
    for i := range result {
        fmt.Println(result[i])
    }
}

