package controllers

import (
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	 "github.com/gin-gonic/gin"
)

func AddAppointment(c *gin.Context) {
	var appointment model.Appointment

	if err := c.ShouldBindJSON(&appointment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Error! Check All Fields"})
		return
	}
	services.Db.Save(&appointment)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated, "message": "Created Successfully","resourceId" : appointment.ID})
}