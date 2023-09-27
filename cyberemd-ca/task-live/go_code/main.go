package main

import (
	"fmt"
	routers "taskgo/routes"
)

func main() {
	r := routers.SetupRouter()
	// listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
	if err := r.Run(); err != nil {
		fmt.Printf("startup service failed, err:%v\n", err)
	}
}
