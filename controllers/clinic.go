package controllers

import (
	"fmt"
	"strconv"
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	 "github.com/gin-gonic/gin"
)

func AddClinic(c *gin.Context) {
	

	
	var clinic model.Clinic
	
	
	if err := c.ShouldBindJSON(&clinic); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status":http.StatusBadRequest, "message": "Error! Check All Fields"})
		return
	}
	var user model.Users
	fmt.Print(clinic.UserID);
    services.Db.First(&user, clinic.UserID)				//Verifica se existe o user		
	
    if user.ID == 0 {
    	c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not exist"})
        return
    }
	if user.UserType != "manager" &&  user.UserType != "admin"{
		c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not have permission"})
		return
	}
	services.Db.Save(&clinic)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully", "resourceId": clinic.ID})
}

func DeleteClinic(c *gin.Context) {
	var clinic model.Clinic
	id := c.Param("id")
	services.Db.First(&clinic, id)
	if clinic.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Not found!"})
		return
	} 
	services.Db.Delete(&clinic)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func AddVet(c *gin.Context) {
	var user model.Users
	id := c.Param("id")
	id_user := c.Param("UserID")
	intID, _ := strconv.Atoi(id)
	
	services.Db.First(&user, id_user)
	if user.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "User does not exist"})
		return
	} 
	if user.UserType == "normal" {													//Se for um user normal
		user.UserType= "vet"
		user.ClinicID=intID;
		services.Db.Save(&user)
		c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Veterinario adicionado!"})
	}else{																			//Se for admin/manager/vet
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Cannot add that user"})
		return
	}
}

func RemVet(c *gin.Context) {
	var user model.Users
	id := c.Param("UserID")
	services.Db.First(&user, id)
	if user.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "User does not exist"})
		return
	} 
	user.UserType = "normal"
	user.ClinicID = 0
	services.Db.Save(&user)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}


func GetClinics(c *gin.Context) {
	var clinics []model.Clinic
	services.Db.Order("id asc").Find(&clinics)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": clinics})
}

func GetVetsClinic(c *gin.Context) {
	var clinic model.Clinic
	var vets []model.Users
	id := c.Param("id")
	services.Db.First(&clinic, id)
	if clinic.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "clinic not found!"})
		return
	}
	fmt.Print(id)
	services.Db.Where("clinic_id = ?", clinic.ID).Select("id,name,email,contact").Find(&vets)  //select id,name,email,contact from users where clinic_id = x;
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": vets})
}


