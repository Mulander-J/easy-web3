package routes

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ethereum/go-ethereum/accounts/keystore"
	"github.com/gin-gonic/gin"
)

type User struct {
	// Username string `json:"username"`
	Password string `json:"password"`
}

func createKs(c *gin.Context) {
	var user User
	if err := c.BindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ks := keystore.NewKeyStore("./tmp", keystore.StandardScryptN, keystore.StandardScryptP)
	account, err := ks.NewAccount(user.Password)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(account.Address.Hex()) // 0x20F8D42FB0F667F2E53930fed426f225752453b3

	c.JSON(http.StatusOK, gin.H{
		"message": account.Address.Hex(),
	})
}

func LoadAccouts(e *gin.Engine) {
	group := e.Group("/account")
	group.POST("", createKs)
}
