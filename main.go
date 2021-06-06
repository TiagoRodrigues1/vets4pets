package main

import (
	"net/http"
	"projetoapi/model"
	"projetoapi/routes"
	"projetoapi/services"
	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

var identityKey = "id"
func init() {
	services.OpenDatabase()
	services.Db.AutoMigrate(&model.Users{})
	services.Db.AutoMigrate(&model.Clinic{})
	services.Db.AutoMigrate(&model.Animal{})
	services.Db.AutoMigrate(&model.Question{})
	services.Db.AutoMigrate(&model.Answer{})
	services.Db.AutoMigrate(&model.Reminder{})
	services.Db.AutoMigrate(&model.Prescription{})
	services.Db.AutoMigrate(&model.Appointment{})
	services.Db.AutoMigrate(&model.Adoption{})
	services.Db.AutoMigrate(&model.Vaccines{})
	defer services.Db.Close()
}


func CORS(c *gin.Context) {

	// First, we add the headers with need to enable CORS
	// Make sure to adjust these headers to your needs
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "*")
	c.Header("Access-Control-Allow-Headers", "*")
	c.Header("Content-Type", "application/json")

	// Second, we handle the OPTIONS problem
	if c.Request.Method != "OPTIONS" {
		
		c.Next()

	} else {
        
		// Everytime we receive an OPTIONS request, 
		// we just return an HTTP 200 Status Code
		// Like this, Angular can now do the real 
		// request using any other method than OPTIONS
		c.AbortWithStatus(http.StatusOK)
	}
}

func main() {

	services.FormatSwagger()

	// Creates a gin router with default middleware:
	// logger and recovery (crash-free) middleware
	router := gin.New()
	router.Use(CORS)
	router.Use(gin.Logger())
	router.Use(gin.Recovery())
	
	// AUTH
	router.NoRoute(func(c *gin.Context) {
		c.JSON(404, gin.H{"code": "PAGE_NOT_FOUND", "message": "Page not found"})
	})

	auth := router.Group("/api/v1/auth")
	{
		auth.POST("/login", routes.GenerateToken)
		auth.POST("/register", routes.RegisterUser)
		auth.POST("/forgot_password", routes.ForgotPassword) //sends email
		auth.POST("/validate_reset_token", routes.ValidateResetToken)
		auth.POST("/reset_password",routes.ResetPassword)
		auth.PUT("/refresh_token", services.AuthorizationRequired(), routes.RefreshToken)
	}

	user := router.Group("api/v1/user")
	user.Use(services.AuthorizationRequired())
	{
		user.GET("/:id", routes.GetUserByID)
		user.PUT("/:id", routes.UpdateUser)
		user.GET("/",routes.GetUsers)
	}

	userAnimals := router.Group("api/v1/userAnimals")
	userAnimals.Use(services.AuthorizationRequired())
	{
		userAnimals.GET("/:id", routes.GetAnimalsFromUserID)
	}

	animal := router.Group("api/v1/animal")
	animal.Use(services.AuthorizationRequired())
	{
		animal.POST("/", routes.AddAnimal)
		animal.DELETE("/:id", routes.DeleteAnimal)
		animal.GET("/:id/:userID", routes.GetAnimalById)
		animal.PUT("/:id", routes.UpdateAnimal)
		animal.GET("/:id",routes.GetAnimalVet)
	}

	appointment := router.Group("api/v1/appointment")
	appointment.Use(services.AuthorizationRequired())
	{
		appointment.POST("/",routes.AddAppointment)
		appointment.PUT("/:id",routes.UpdateAppointment)
		appointment.DELETE("/:id",routes.DeleteAppointment)
		appointment.GET("/vet/:id",routes.GetAppointmentByVetID)
	}
	
	appointment_user := router.Group("api/v1/appointmentOfuser")
    appointment_user.Use(services.AuthorizationRequired())
    {
        appointment_user.GET("/:id",routes.GetAppointmentsOfUser)
    }
	adoption := router.Group("api/v1/adoption")
	adoption.Use(services.AuthorizationRequired())
	{
		adoption.POST("/", routes.AddAdoption)
		adoption.DELETE("/:id",routes.DeleteAdoption)
		adoption.GET("/:id",routes.GetAdoptionsByUser)
		adoption.PUT("/:id",routes.UpdateAdoption)
	}

	adoptionbytime := router.Group("api/v1/adoptionByTime")
	adoptionbytime.Use(services.AuthorizationRequired())
	{
		adoptionbytime.GET("/", routes.GetAdoptionsByTime)
	}

	clinic := router.Group("api/v1/clinic")
	clinic.Use(services.AuthorizationRequired())
	{
		clinic.POST("/", routes.AddClinic)
		clinic.DELETE("/:id",routes.DeleteClinic)
		clinic.PUT("/:id/:UserID",routes.AddVet)
		clinic.GET("/",routes.GetClinics)
	}

	vetsclinic := router.Group("api/v1/vetsClinic")
	vetsclinic.Use(services.AuthorizationRequired())
	{
		vetsclinic.GET("/:id",routes.GetVetsClinic);
	}

	clinic1 := router.Group("api/v1/clinicRem")
	clinic1.Use(services.AuthorizationRequired())
	{
		clinic1.PUT("/:UserID",routes.RemVet)
	}

	vaccine := router.Group("api/v1/vaccine")
	vaccine.Use(services.AuthorizationRequired())
	{	
		vaccine.POST("/", routes.AddVaccine)
		vaccine.DELETE("/:id/",routes.DeleteVaccine)
		vaccine.GET("/:id/",routes.GetVaccines)		
	}
	question := router.Group("api/v1/question")
    question.Use(services.AuthorizationRequired())
    {
        question.POST("/", routes.AddQuestion)
        question.DELETE("/:id", routes.DeleteQuestion)
        question.GET("/:id", routes.GetQuestion)
		question.PUT("/:id",routes.UpdateQuestion)
    }

    questions := router.Group("api/v1/questions")
    questions.Use(services.AuthorizationRequired())
    {
        questions.GET("/", routes.GetQuestionByTime)
    
    }

    questions_user := router.Group("api/v1/questionsByUser")
    questions_user.Use(services.AuthorizationRequired())
    {
        questions_user.GET("/:id", routes.GetQuestionsOfUser)
    
    }

    answer := router.Group("api/v1/answer")
    answer.Use(services.AuthorizationRequired())
    {
        
        answer.POST("/", routes.AddAnswer)
        answer.DELETE("/:id",routes.DeleteAnswer)
        answer.GET("/:id",routes.GetAnswers)
    }

    answer_user := router.Group("api/v1/answersByUser")
    answer_user.Use(services.AuthorizationRequired())
    {
        answer_user.GET("/:id",routes.GetAnswersOfUser)
    }

	usernormal := router.Group("api/v1/userNormal")
	usernormal.Use(services.AuthorizationRequired())
	{
		usernormal.GET("/",routes.GetNormalUsers)
	}

	uservet := router.Group("api/v1/userVet")
	uservet.Use(services.AuthorizationRequired())
	{
		uservet.GET("/:id",routes.GetVetUsers)
	}

	prescription := router.Group("api/v1/prescription")
	prescription.Use(services.AuthorizationRequired())
	{
		prescription.POST("/",routes.AddPrescription)
		prescription.DELETE("/:id",routes.DeletePrescription)
		prescription.GET("/:id",routes.GetPrescriptionsByAnimalID)
	}

	prescriptionUser := router.Group("api/v1/prescriptionUser")
	prescriptionUser.Use(services.AuthorizationRequired())
	{
		prescriptionUser.GET("/:id",routes.GetPrescriptionsByUserID)
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	router.Run(":8080")
}
