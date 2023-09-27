package routers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func pong(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "pong",
	})
}

func SetupRouter() *gin.Engine {
	r := gin.Default()

	/// PING
	r.GET("/ping", pong)

	return r
}
