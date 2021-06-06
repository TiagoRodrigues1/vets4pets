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
    services.Db.First(&user, question.UserID)
    if user.ID == 0 {
    	c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not exist"})
        return
    }
	services.Db.Save(&question)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully", "resourceId": question.ID})
}

func UpdateQuestion(c *gin.Context) {
	var question model.Question
	id := c.Param("id")

	services.Db.First(&question, id)
	if question.ID == 0 {
		c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Question not found!"})
		return
	} 

	if err := c.ShouldBindJSON(&question); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest, "message": "Check request!"})
		return
	}

	services.Db.Save(question)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Update succeeded!"})
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
	services.Db.Where("question_id= ?", question.ID).Find(&answers)	
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

func GetQuestionsOfUser(c *gin.Context) {
	var user model.Users
	var questions []model.Question
	id := c.Param("id")
	services.Db.First(&user, id)
	if user.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
		return
	}
	services.Db.Where("user_id = ?", user.ID).Find(&questions)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": questions})
}