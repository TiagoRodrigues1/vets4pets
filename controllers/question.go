package controllers

import (
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	 "github.com/gin-gonic/gin"
)

func AddQuestion(c *gin.Context) {
	
	var question model.Question
	if err := c.ShouldBindJSON(&question); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status":http.StatusBadRequest, "message": "Error! Check All Fields"})
		return
	}
	var user model.Users
    services.Db.First(&user, question.UserID)				//Verifica se existe o user																	//Verifica qual se o User exist
    if user.ID == 0 {
    	c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not exist"})
        return
    }
	question.Answers=0
	services.Db.Save(&question)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully", "resourceId": question.ID})
}

func DeleteQuestion(c *gin.Context) {
	var question model.Question
	id := c.Param("id")

	services.Db.First(&question, id)
	if question.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Not found!"})
		return
	} 
	services.Db.Delete(&question)

	var answers []model.Answer
	services.Db.Where("question_id= ?", question.ID).Find(&answers)				//Procura todas as respostas daquela pergunta 
	
	//services.Db.Delete(&answers)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func GetQuestionByTime(c *gin.Context) {
	var questions []model.Question
	services.Db.Order("created_at desc").Find(&questions)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": questions})
}

func GetQuestion(c *gin.Context) {
	var question model.Question
	id := c.Param("id")
	services.Db.First(&question, id)
	if question.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "question not found!"})
		return
	} 
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": question})
}



