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
	services.Db.Save(&question)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully", "resourceId": question.ID})
}
