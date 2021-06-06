package controllers

import (
    "fmt"
    "net/http"
    "projetoapi/model"
    "projetoapi/services"
    "github.com/gin-gonic/gin"
)

func GetUserByID(c *gin.Context) { //Ir buscar o utilizador por ID
    var user model.Users
    id := c.Param("id")
    services.Db.Select("id,name,email,contact,user_type,username,profile_picture").Where("id = ?",id).Find(&user)

    if user.ID == 0 {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not Found!"})
        return
    }
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": user})
}

func UpdateUser(c *gin.Context) {
    var user model.Users
    id := c.Param("id")
    services.Db.First(&user, id)
    if user.ID == 0 {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
        return
    }
    fmt.Println(user.Password);
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Check request!"})
        return
    }
    services.Db.Save(user)
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Update succeeded!"})
}

func GetAnimalsFromUserID(c *gin.Context) {
    var user model.Users
    var animals []model.Animal
    id := c.Param("id")
    services.Db.First(&user, id)
    if user.ID == 0 {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
        return
    }
    services.Db.Where("user_id = ?", user.ID).Find(&animals)

    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": animals})
}

func GetUsers(c *gin.Context) {
	var users []model.Users 
    services.Db.Select("id,name,email,contact,user_type,username").Find(&users)
    if(len(users) <= 0){
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Users not found!"})
        return
    }
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": users})
}

func GetNormalUsers(c *gin.Context) { //retorna todos user que user_type é normal
    var users []model.Users
    services.Db.Select("id,name,email,contact,user_type,username").Where("user_type = ?","normal").Find(&users)
    if(len(users) <= 0) {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Users not found!"})
        return
    }
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": users})
}

func GetVetUsers(c *gin.Context) { //retorna todos user que user_type é normal
    var users []model.Users
    id := c.Param("id")
    services.Db.Select("id,name,email,contact,user_type,username,profile_picture").Where("user_type = ? AND clinic_id = ? ","vet",id).Find(&users)
    if(len(users) <= 0) {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Users not found!"})
        return
    }
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": users})
}