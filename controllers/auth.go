package controllers

import (
	"fmt"
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"github.com/dgrijalva/jwt-go"
	"io/ioutil"
)
var JwtKey = GetSecretKey()

func GetSecretKey() []byte {
	b, err := ioutil.ReadFile("config/secretKey.key")
	if err != nil {
		fmt.Print(err)
	}
	secretKey := string(b)
	return []byte(secretKey)
}

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
	token := services.GenerateTokenJWT(usr)

	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Access denied!"})
		return
	}
	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Success!", "token": token, "ID" : usr.ID, "userType": usr.UserType, "profilePicture" : usr.ProfilePicture})
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

	services.Db.Find(&usr, "username = ?",creds.Username)
	if usr.Username == creds.Username {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Username already registered"})
		return
	}

	creds.Password = hashAndSalt([]byte(creds.Password)) //fazer o hash da pw
	creds.UserType="normal"								 //todos os users são normal apos o registo
	services.Db.Save(&creds)

	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Success!", "User ID": creds.ID})
}

func RefreshHandler(c *gin.Context) {

	var user model.Users
	services.Db.First(&user, c.GetHeader("email"))	
	
	token := services.GenerateTokenJWT(user)

	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Unauthorized Acess"})
		return
	}

	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusNoContent, "message": "Token Sucessefully Updated", "token": token})
}

func ForgotPasswordHandler (c *gin.Context) {
	var data model.ResendCommand
	var usr model.Users
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Bad request!"})
		return
	}
	services.OpenDatabase()
	services.Db.Find(&usr, "email = ?", data.Email)

	if usr.Email == "" {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Please Register before trying to recover password"})
		return
	}

	resetToken := services.GenerateTokenJWT(usr)
	if resetToken == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Bad Token"})
		return
	}
	link := "http://localhost:4200/account/reset-password?token=" + resetToken 
	email := services.SendMail(usr.Email,link) 

	defer services.Db.Close()
	if(email == true) {
		c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Check your email"})
		return
	} else {
		c.JSON(http.StatusInternalServerError, gin.H{"status": http.StatusInternalServerError, "message": "An issue occured sending you an email"})
		return
	}
}

func ValidateToken (c *gin.Context) {
	var data model.Token
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Bad request!"})
		return
	}

	ret := validateTokenJWT(data.Token)
	if ret == false {
		c.JSON(http.StatusUnauthorized, gin.H{"status": http.StatusUnauthorized, "message": "Invalid Token"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Token Valid"})
		return
}

func ResetPassword (c *gin.Context) {
	var data model.PasswordResetCommand
	var usr model.Users
	if err := c.ShouldBindJSON(&data); err != nil {
		fmt.Println(data.Token)
		fmt.Println(data.Password)
		fmt.Println(data.PasswordConfirm)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Bad request!"})
		return
	}

	if data.Password != data.PasswordConfirm {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Passwords don't match!"})
		return
	}

	resetToken := data.Token

	userID, _ := services.DecodeNonAuthToken(resetToken)
	services.OpenDatabase()
	services.Db.Find(&usr, "id = ?", userID)

	if usr.Email == "" {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User Not Found"})
		return
	}

	usr.Password = hashAndSalt([]byte(data.Password)) //fazer o hash da pw
	services.Db.Save(usr)
	defer services.Db.Close()
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Success!"})
	return
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

func validateTokenJWT(token string) bool {
	claims := &model.Claims{}
	tkn, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
		return JwtKey, nil
	})

	if err != nil {
		if err == jwt.ErrSignatureInvalid {
			return false
		}
	}

	if !tkn.Valid {
		return false
	}

	return true
}