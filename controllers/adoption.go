package controllers

import (
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	 "github.com/gin-gonic/gin"
)

func AddAdoption(c *gin.Context) {
	var adoption model.Adoption
	if err := c.ShouldBindJSON(&adoption); err != nil {
		c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! Check All Fields"})
		return
	}
	var user model.Users
    services.Db.First(&user, adoption.UserID)				//Verifica se existe o user																	//Verifica qual se o User exist
    if user.ID == 0 {
    	c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not exist"})
        return
    }
	adoption.Adopted=false;
	services.Db.Save(&adoption)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully","resourceId" : adoption.ID})
}

func DeleteAdoption(c *gin.Context) {
	var adoption model.Adoption
	id := c.Param("id")

	services.Db.First(&adoption, id)
	if adoption.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "None found!"})
		return
	} 
	services.Db.Delete(&adoption)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func GetAdoptionsByUser(c *gin.Context) {
	var user model.Users
	var adoptions []model.Adoption
	id := c.Param("id")
	services.Db.First(&user, id)
	if user.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
		return
	}
	services.Db.Where("user_id = ?", user.ID).Find(&adoptions)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": adoptions})
}

func GetAdoptionsByTime(c *gin.Context) {
	var adoptions []model.Adoption
	services.Db.Order("created_at desc").Find(&adoptions)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": adoptions})
}


func UpdateAdoption(c *gin.Context) {
	var adoption model.Adoption
	id := c.Param("id")

	services.Db.First(&adoption, id)
	if adoption.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Adoption not found!"})
		return
	} 

	if err := c.ShouldBindJSON(&adoption); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Check request!"})
		return
	}

	services.Db.Save(adoption)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Update succeeded!"})
}