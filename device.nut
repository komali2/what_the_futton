#require "Button.class.nut:1.2.0"

button <- Button(hardware.pin5, DIGITAL_IN_PULLUP, Button.NORMALLY_HIGH,
    function() {
        server.log("Button pressed");
        agent.send("fu_crease", "WHY");
    }
);