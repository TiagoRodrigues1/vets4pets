package controllers

import (
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	"github.com/gin-gonic/gin"
)

func GetUserByID(c *gin.Context) { //Ir buscar o utilizador por ID
	var user model.Users
	id := c.Param("id")
	services.Db.First(&user,id)
	//fmt.Println(user)
	if(user.ID == 0) {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "User not Found!"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK,"data" : user})
}
