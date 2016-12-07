var casper = require('casper').create({verbose: true});

var formSelector = 'form#login-form',
    url = 'https://collegeprep.parentstudentportal.com/mod.php/portal_index.php',
    username = casper.cli.get(0), 
    password = casper.cli.get(1)

function handler(msg, trace) {
	casper.log('error: ' + msg + " " + trace, 'error');
}

casper.on('remote.message', function(resource) {
    this.log('remote message: ' + resource, 'info');
});

casper.on('error', handler);

casper.on('page.error', handler);

casper.start(url).viewport(1600,1000);

casper.waitForSelector(formSelector);

casper.then(function(){

	casper.log("loaded",'info');
	if (this.exists(formSelector)) {
		this.log("logging in",'info')
		this.sendKeys("#username", username)
		this.sendKeys("#password", password)
		this.log("filled",'info')		
		this.click("button")
		this.log("clicked",'info')
	} else {
		this.echo("wrong page")
		this.exit(1)
	}	
});

casper.waitForSelector("li.sidebar-navigation_item:first-child")

casper.then(function(){
	this.log("getting grades", 'info')
	casper.waitForSelector("li.sidebar-navigation_item:first-child")
	if (this.exists("li.sidebar-navigation_item:first-child")) {
		this.log("clicking link",'info')		
		this.click("li.sidebar-navigation_item:first-child")
	} else {
		this.log("error",'error')
	}
})

casper.waitForText("You may view your grades")

casper.then(function(){
	this.log("got grades",'info')
	this.evaluate(function(){
		elts = document.querySelectorAll("*");
		[].forEach.call(elts, function (t){
			t.removeAttribute("align");
			t.removeAttribute("ALIGN");
			console.info("removed t align")
		});

		// elts = document.querySelectorAll("center");
		// [].forEach.call(elts, function (c){
		// 	r = document.createElement("h3")
		// 	r.innerHTML = c.textContent
		// 	c.replaceWith(r)
		// })

		elts = document.querySelectorAll("div.classname");
		[].forEach.call(elts, function (d){
			d.parentNode.insertBefore(document.createElement("br"), d)
			d.parentNode.insertBefore(document.createElement("br"), d)
			console.info("added brs")
		});

		elts = document.querySelectorAll("form, div.pagedescription, a, link, hr");
		[].forEach.call(elts, function (f){
			f.remove();

		});
		
	});

	grades = this.fetchText("div.grade_div b").replace(/(Computed Grade: *|No Grade)+/g,' ').trim()
	this.echo("<div class='grade_summary'>" + grades + "</div>")
	html = this.evaluate(function(){
		return document.querySelector("div.student_content").innerHTML
	})

	this.echo(html)
	this.log('done','info')
	this.exit(0)
})

casper.run(function() {
});

