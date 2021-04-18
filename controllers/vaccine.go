package controllers

import
 (
	_ "fmt"
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	 "github.com/gin-gonic/gin"
	 
)

func AddVaccine(c *gin.Context) {
	var vaccine model.Vaccines
	if err := c.ShouldBindJSON(&vaccine); err != nil {
		c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! Check All Fields"})
		return
	}

	var animal model.Animal
	services.Db.First(&animal, vaccine.AnimalID)		//Verifica se existe o animal
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Animal não existe"})
		return
	} 
	vaccine.Taken=false
	/*var user model.Users
    services.Db.First(&user, Vaccine.UserID)				//Verifica se existe o user																	//Verifica qual se o User exist
    if user.ID == 0 {
    	c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not exist"})
        return
    }*/
	services.Db.Save(&vaccine)						//Guarda a nova pergunta
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully","resourceId" : vaccine.ID})
}

func DeleteVaccine(c *gin.Context) {
	var vaccine model.Vaccines
	id := c.Param("id")
	services.Db.First(&vaccine, id)
	if vaccine.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Vaccine not found!"})
		return
	} 
	services.Db.Delete(&vaccine)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func GetVaccines(c *gin.Context) {
	var animal model.Animal
	var vaccines []model.Vaccines
	id := c.Param("id")
	services.Db.First(&animal, id)
	if animal.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "animal not found!"})
		return
	}
	services.Db.Where("animal_id = ?", animal.ID).Find(&vaccines)	

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": vaccines})
}