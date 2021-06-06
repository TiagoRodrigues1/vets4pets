package controllers

import (
	"fmt"
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	"github.com/gin-gonic/gin"
)

func AddAnimal(c *gin.Context) {
	var animal model.Animal
	if err := c.ShouldBindJSON(&animal); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Error! Check All Fields"})
		return
	}
	var user model.Users
    services.Db.First(&user, animal.UserID)	
    if user.ID == 0 {
    	c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusNotFound,"message": "Error! User does not exist"})
        return
    }
	
	services.Db.Save(&animal)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated, "message": "Created Successfully","resourceId" : animal.ID})
}

func DeleteAnimal(c *gin.Context) {
	var animal model.Animal
	id := c.Param("id")
	services.Db.First(&animal, id)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "None found!"})
		return
	} 
	services.Db.Delete(&animal)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func GetAnimalById(c *gin.Context) {
	var animal model.Animal
	id := c.Param("id")
	userID := c.Param("userID")
	services.Db.First(&animal, id)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Animal not found!"})
		return
	} 
	
	userString := fmt.Sprint(animal.UserID)
	if(userString != userID) {
		c.JSON(http.StatusUnauthorized,gin.H{"status": http.StatusUnauthorized, "message": "This animal is from other user"})
		return
	} 
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": animal})
}

func GetAnimalVet (c *gin.Context) {
	var animal model.Animal
	id := c.Param("id")
	services.Db.First(&animal, id)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Animal not found!"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": animal})
}

func UpdateAnimal(c *gin.Context) {
	var animal model.Animal
	id := c.Param("id")

	services.Db.First(&animal, id)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Animal not found!"})
		return
	} 

	if err := c.ShouldBindJSON(&animal); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Check request!"})
		return
	}

	services.Db.Save(animal)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Update succeeded!"})
}

