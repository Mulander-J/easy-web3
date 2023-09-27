package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func pong(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "pong",
	})
}

func LoadCommon(e *gin.Engine) {
	e.GET("/ping", pong)
}
