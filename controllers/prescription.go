package controllers

import (
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	"github.com/gin-gonic/gin"
	"fmt"
	"time"
)

func AddPrescription(c *gin.Context) { 
	var prescription model.Prescription
	if err := c.ShouldBindJSON(&prescription); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Error! Check All Fields"})
		return
	}
	var animal model.Animal
	services.Db.First(&animal,prescription.AnimalID)
	fmt.Println(prescription.AnimalID)
	fmt.Println(animal.ID)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Animal Not Found"})
		return
	} 
	services.Db.Save(&prescription)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated, "message": "Created Successfully","resourceId" : prescription.ID})
}

func DeletePrescription(c *gin.Context) {
	var prescription model.Prescription
	id := c.Param("id")
	services.Db.First(&prescription, id)
	if prescription.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "None found!"})
		return
	} 
	if prescription.AnimalID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Animal Not Found"})
		return
	} 
	services.Db.Delete(&prescription)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func GetPrescriptionsByAnimalID(c *gin.Context) {
	var animal model.Animal
	var prescription []model.Prescription
	id := c.Param("id")
	services.Db.First(&animal, id)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Animal not found!"})
		return
	}
	services.Db.Where("animal_id = ?", animal.ID).Find(&prescription)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": prescription})
}

func GetPrescriptionsByUserID(c *gin.Context) {
	var user model.Users
    var animals []model.Animal
    var prescription_temp []model.Prescription
    var prescription []model.Prescription
    id := c.Param("id")
    services.Db.First(&user, id)
    if user.ID == 0 {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
        return
    }
    services.Db.Where("user_id = ?", user.ID).Find(&animals)
    for _,animal := range animals {
        services.Db.Where("animal_id= ? AND date > ?", animal.ID,time.Now()).Find(&prescription_temp)
        for _,prescription_aux := range prescription_temp {
            prescription=append(prescription,prescription_aux)
        }    
    }    
	if len(prescription) <= 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound,"message" : "Pets of User don't have Prescriptions"})  
		return
	}
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": prescription})  
}