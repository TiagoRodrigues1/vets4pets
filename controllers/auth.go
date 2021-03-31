package controllers

import (
	"fmt"
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	"github.com/gin-gonic/gin"

	"golang.org/x/crypto/bcrypt"
)

func LoginHandler(c *gin.Context) {
	var creds model.Users
	var usr model.Users

	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Bad request!"})
		return
	}
	services.OpenDatabase()
	services.Db.Find(&usr, "email = ?", creds.Email)
	if usr.Email == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Invalid User!"})
		return
	} else if usr.Email != "" && comparePasswords(usr.Password,[]byte(creds.Password)) == false {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Email Or Password Incorrect !"})
		return
	}

	token := services.GenerateTokenJWT(creds)

	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Access denied!"})
		return
	}
	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Success!", "token": token})
}

func RegisterHandler(c *gin.Context) {
	var creds model.Users
	var usr model.Users

	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Bad request!"})
		return
	}
	services.OpenDatabase()
	services.Db.Find(&usr, "email = ?", creds.Email)

	if usr.Email == creds.Email { //verficação de existencia do email na BD 
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Email already registered"})
		return
	}
	creds.Password = hashAndSalt([]byte(creds.Password)) //fazer o hash da pw
	services.Db.Save(&creds)

	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Success!", "User ID": creds.ID})
}

func RefreshHandler(c *gin.Context) {

	user := model.Users{
		Email: c.GetHeader("email"),
	}

	token := services.GenerateTokenJWT(user)

	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Acesso não autorizado"})
		return
	}

	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusNoContent, "message": "Token atualizado com sucesso!", "token": token})
}

func hashAndSalt(password []byte) string {
	hash, err := bcrypt.GenerateFromPassword(password, 10)
	if err != nil { //ver se deu erro 
        fmt.Println(err)
    }
	return string(hash)
}

func comparePasswords(hashedPwd string, plainPwd []byte) bool {
	byteHash := []byte(hashedPwd)
    err := bcrypt.CompareHashAndPassword(byteHash, plainPwd)
    if err != nil {
        fmt.Println(err)
        return false
    }
    return true
}