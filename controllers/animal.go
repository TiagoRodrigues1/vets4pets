package controllers

import (
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
	services.Db.Save(&animal)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated, "message": "Created Successfully","resourceId" : animal.ID})
}
