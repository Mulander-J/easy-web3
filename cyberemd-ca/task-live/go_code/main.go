package main

import (
	"fmt"

	routers "taskgo/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	routers.LoadCommon(r)
	routers.LoadAccouts(r)
	// listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
	if err := r.Run(); err != nil {
		fmt.Printf("startup service failed, err:%v\n", err)
	}
}
