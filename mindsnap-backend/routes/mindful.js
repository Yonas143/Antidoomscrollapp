const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const ctrl = require("../controllers/mindfulController");

router.post("/", auth, ctrl.create);
router.get("/", auth, ctrl.getAll);
router.put("/:id", auth, ctrl.update);
router.delete("/:id", auth, ctrl.delete);

const role = require("../middleware/roleMiddleware");

// Admin-only route to see ALL activities (not just own)
router.get("/all", auth, role("admin"), async (req, res) => {
  const allActivities = await MindfulActivity.find();
  res.json(allActivities);
});


module.exports = router;
