package hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.DateFormat;

@SpringBootApplication
@RestController
public class Application {

  @RequestMapping("/")
  public String home() {
	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date date = new Date();
	String display_date = dateFormat.format(date);

    return "Hello Docker World coming to you from Spring Boot!<br>Update the repo<br> testing webhook to jenkins<br>"
		+display_date	;

  }

  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }

}
