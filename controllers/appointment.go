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

func DeleteAppointment(c *gin.Context) {
	var appointment model.Appointment
	id := c.Param("id")

	services.Db.First(&appointment, id)
	if appointment.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "None found!"})
		return
	} 
	services.Db.Delete(&appointment)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func UpdateAppointment(c *gin.Context) {
	var appointment model.Appointment
	id := c.Param("id")

	services.Db.First(&appointment, id)
	if appointment.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Appointment not found!"})
		return
	}

	if err := c.ShouldBindJSON(&appointment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Check request!"})
		return
	}

	services.Db.Save(appointment)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Update succeeded!"})
}