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

	services.Db.Where("date = ? AND vet_id = ?", appointment.Date, appointment.VetID).Find(&appointment)
	if appointment.ID != 0 {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Appoitntment already exists, please choose another Date or Hour"})
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

func GetAppointmentByVetID(c *gin.Context) {
	var appointments []model.Appointment
	var user model.Users
	id := c.Param("id")
	if id == "undefined" {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
		return
	}
	services.Db.First(&user, id)
	if user.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
		return
	}
	if(user.UserType != "vet") {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusUnauthorized, "message": "User does not have permission"})
		return
	}
	services.Db.Where("vet_id = ? AND canceled = ?", user.ID,false).Find(&appointments)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": appointments})

}

func  GetAppointmentsOfUser(c *gin.Context) {
    var user model.Users
    var animals []model.Animal
    var appointments_temp []model.Appointment
    var appointments []model.Appointment
    id := c.Param("id")
    services.Db.First(&user, id)
    if user.ID == 0 {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
        return
    }
    services.Db.Where("user_id = ?", user.ID).Find(&animals)
    for _,animal := range animals {
        services.Db.Where("animal_id= ?", animal.ID).Find(&appointments_temp)
        for _,appointments_aux := range appointments_temp{
            appointments=append(appointments,appointments_aux)
        }    
    }    
	if len(appointments) <= 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound,"message" : "User does not have any appointments"})  
		return
	}
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": appointments})  
}