const birthDate = new Date("1994-12-31T00:00:00Z"); // Your birth date
// Import necessary AGS modules
const { exec } = ags.util;

// Define the script you want to run
const scriptToRun =
  "/home/simon/nixos-dotfiles/home/scripts/start_work_windu.sh"; // Replace with the path to your script

const getCurrentDayPercentage = () => {
  const now = new Date();
  const currentDay = now.getDate(); // Current day of the month
  const totalDaysInMonth = new Date(
    now.getFullYear(),
    now.getMonth() + 1,
    0,
  ).getDate(); // Total days in the month
  return Math.round((currentDay / totalDaysInMonth) * 100); // Convert to percentage and round
};
// Helper function to get the current month name
const getCurrentMonthName = () => {
  const now = new Date();
  return now.toLocaleString("default", { month: "long" }); // Get month name (e.g., January, February)
};

// Create a Variable to hold the calculated age
const age = Variable("", {
  poll: [
    50, // Update every second
    function () {
      const now = new Date();
      const calculatedAge =
        (now.getTime() - birthDate.getTime()) / (1000 * 60 * 60 * 24 * 365.25); // Age in years
      return calculatedAge.toFixed(12); // Format to 5 decimal places
    },
  ],
});

// Create a widget to display the age
const Bar = (/** @type {number} */ monitor) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["bottom", "right"],
    css: "background-color: transparent;", // Transparent background
    exclusivity: "exclusive",
    layer: "bottom",
    child: Widget.CenterBox({
      center_widget: Widget.Label({
        css: "color: #e0def4; background:#1f1d2e; opacity: 0.6; padding: 8px;  font-size: 40px; margin-bottom: 32px; border-radius: 8px; margin-right: 48px;",
        hpack: "center",
        label: age.bind().as((value) => `${value}`), // Bind age to the label and format
      }),
    }),
  });

// Create a widget to display "May" in the center of the screen

// Create a widget to display the current month in the center of the screen
const CenterWidget = (/** @type {number} */ monitor) =>
  Widget.Window({
    monitor,
    name: `center${monitor}`,
    css: "background-color: transparent; margin-bottom: 96px", // Transparent background
    exclusivity: "exclusive",
    layer: "bottom",
    child: Widget.CenterBox({
      spacing: 8,
      vertical: true,
      center_widget: Widget.Label({
        css: "font-size: 56px;  font-weight: bold; color:#363a4f;",
        hpack: "center",
        label: getCurrentMonthName(), // Bind the current month to the label
      }),

      endWidget: Widget.LevelBar({
        css: `
          background-color: #1f1d2e; /* Background of the bar */
          border-radius: 8px;       /* Round corners of the bar */
          color: #4caf50; /* Green fill for progress */
        `,
        maxValue: 100,
        minValue: 0,
        value: getCurrentDayPercentage(),
      }),
    }),
  });

// Create a widget to trigger the script on click

const ScriptTriggerWidget = (/** @type {number} */ monitor) =>
  Widget.Window({
    monitor,
    name: `scriptTrigger${monitor}`,
    css: "background-color: rgba(255, 0, 0, 0.5);", // Temporary red background for visibility
    anchor: ["top", "right"],
    exclusivity: "exclusive",
    layer: "bottom", // Ensure it's on top of other widgets
    child: Widget.Label({
      css: `
          font-size: 24px;
          font-weight: bold;
          color: #ffffff;
          padding: 8px;
          border: 2px solid #4caf50;
          border-radius: 8px;
          cursor: pointer;
        `,
      hpack: "center",
      label: "Run Script", // Text displayed on the widget
      // on_click: () => {
      //   console.log("Executing script:", scriptToRun); // Debugging log
      //   exec(scriptToRun); // Execute the script on click
      // },
    }),
  });

App.config({
  windows: [Bar(0), CenterWidget(0), ScriptTriggerWidget(0)],
});
