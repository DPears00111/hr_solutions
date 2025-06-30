<template>
  <div class="payroll-view">
        <div class="header">
            <h1>Performance Review</h1>
            <div class="header-actions">
                <input type="text" placeholder="Search" v-model="searchQuery" @input="filterPayroll">
            </div>
        </div>
  </div>
  <div class="performance-page">
    <div class="content">
      <!-- Employee List Panel -->
      <aside class="employee-list">
        <h3>Select an Employee</h3>
        <ul>
          <li v-for="emp in employees" :key="emp.id">
            <button
              :class="{ active: emp.id === employee?.id }"
              @click="selectEmployee(emp)"
            >
              {{ emp.name }}
            </button>
          </li>
        </ul>
      </aside>

      <!-- Main Section -->
      <div class="main-section animate__animated animate__fadeInUp">
        <div class="header-actions" style="margin-bottom: 1rem;">
          <div class="action-buttons">
            <button @click="showLeaderboard = !showLeaderboard" style="background-color: #2c81b9; color: white; border-radius: 5px; padding: 0.6rem 1.2rem; font-weight: bold;">
              {{ showLeaderboard ? "Hide Leaderboard" : "Show Leaderboard" }}
            </button>
          </div>
        </div>

        <!-- Leaderboard Section -->
        <section class="leaderboard animate__animated animate__fadeIn" v-if="showLeaderboard">
          <h2>🏆 Employee Performance Leaderboard</h2>
          <table class="leaderboard-table animate__animated animate__fadeInUp">
            <thead>
              <tr>
                <th>Rank</th>
                <th>Name</th>
                <th>Rating</th>
                <th>Performance</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(emp, index) in sortedEmployees" :key="emp.id" class="animate__animated animate__fadeInUp">
                <td>{{ index + 1 }}</td>
                <td>{{ emp.name }}</td>
                <td>{{ emp.overallRating }}</td>
                <td>
                  <div class="bar-container">
                    <div
                      class="bar-fill"
                      :style="{ width: (emp.overallRating * 20) + '%' }"
                    ></div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </section>

        <!-- Employee Review Panel -->
        <section class="performance-review animate__animated animate__fadeIn" v-if="employee" ref="reviewSection">
          <div class="header-actions">
            <h2>{{ employee.name || 'New Employee' }} — Performance Review</h2>
            <div class="action-buttons">
              <button @click="generatePDF" class="download-btn">📄 Download PDF</button>
              <button @click="startNewReview" class="new-review-btn btn btn-secondary">➕ Add New Review</button>
            </div>
          </div>

          <!-- Info Table -->
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Employee ID</th>
                <th>Job Title</th>
                <th>Department</th>
                <th>Reviewer</th>
                <th>Review Date</th>
                <th>Overall Rating</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input v-model="employee.id" /></td>
                <td><input v-model="employee.jobTitle" /></td>
                <td><input v-model="employee.department" /></td>
                <td><input v-model="employee.reviewerName" /></td>
                <td><input v-model="employee.reviewDate" type="date" /></td>
                <td>
                  <select v-model="overallRating">
                    <option>Excellent</option>
                    <option>Good</option>
                    <option>Average</option>
                    <option>Poor</option>
                    <option>Bad</option>
                  </select>
                </td>
              </tr>
            </tbody>
          </table>

          <!-- Performance Summary -->
          <h3>Performance Summary</h3>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Achievements</th>
                <th>General Feedback</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><textarea v-model="review.achievements" /></td>
                <td><textarea v-model="review.generalFeedback" /></td>
              </tr>
            </tbody>
          </table>

          <!-- Category Review -->
          <h3>Category Review</h3>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Category</th>
                <th>Rating</th>
                <th>Comments</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="cat in review.categories" :key="cat.name">
                <td>{{ cat.name }}</td>
                <td>
                  <select v-model="cat.rating">
                    <option v-for="n in 5" :key="n" :value="n">{{ n }}</option>
                  </select>
                </td>
                <td><input v-model="cat.comments" /></td>
              </tr>
            </tbody>
          </table>

          <!-- Goals -->
          <h3>Goals and Objectives</h3>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Set Goal</th>
                <th>Progress</th>
                <th>Next Goal</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(goal, i) in review.goals" :key="i">
                <td><input v-model="goal.setGoal" /></td>
                <td><input v-model="goal.progress" /></td>
                <td><input v-model="goal.newGoal" /></td>
              </tr>
            </tbody>
          </table>

          <!-- Comments -->
          <h3>Comments</h3>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Reviewer Comments</th>
                <th>Employee Comments</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><textarea v-model="review.reviewerComments" /></td>
                <td><textarea v-model="review.employeeComments" /></td>
              </tr>
            </tbody>
          </table>

          <div class="footer">
            <button @click="submitReview" class="submit-btn">Submit Review</button>
          </div>
        </section>
      </div>
    </div>

    <!-- Review Modal Popup -->
    <div v-if="showPopup" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h2>{{ employee.name }} — Submitted Review</h2>
        <p><strong>Overall Rating:</strong> {{ overallRating }}</p>

        <h3>Achievements</h3>
        <p>{{ review.achievements }}</p>

        <h3>General Feedback</h3>
        <p>{{ review.generalFeedback }}</p>

        <h3>Reviewer Comments</h3>
        <p>{{ review.reviewerComments }}</p>

        <h3>Employee Comments</h3>
        <p>{{ review.employeeComments }}</p>

        <button @click="closeModal">Close</button>
      </div>
    </div>
  </div>
</template>




<script>
import html2pdf from "html2pdf.js";
import employees from "@/assets/employees.json";

export default {
  name: "PerformanceReviews",
  data() {
    return {
      employees: employees,
      employee: null,
      overallRating: "",
      review: {},
      showPopup: false,
      showLeaderboard: false // 👈 leaderboard toggle
    };
  },
  mounted() {
    if (this.employees.length) {
      this.selectEmployee(this.employees[0]);
    }
  },
  computed: {
    sortedEmployees() {
      return [...this.employees].sort((a, b) => b.overallRating - a.overallRating);
    },
  },
  methods: {
    selectEmployee(emp) {
      this.employee = emp;
      this.overallRating = emp.overallRating;
      this.review = { ...emp.review }; // deep copy to prevent reactive overwrite
    },
    generatePDF() {
      html2pdf()
        .from(this.$refs.reviewSection)
        .set({ filename: `Review-${this.employee.name}.pdf` })
        .save();
    },
    submitReview() {
      if (this.employee) {
        this.employee.overallRating = this.overallRating;
        this.employee.review = { ...this.review }; // update employee's review
      }
      this.showPopup = true;
    },
    closeModal() {
      this.showPopup = false;
    },
    startNewReview() {
      this.employee = {
        name: '',
        id: '',
        jobTitle: '',
        department: '',
        reviewerName: '',
        reviewDate: new Date().toISOString().split('T')[0],
        overallRating: ''
      };
      this.overallRating = '';
      this.review = {
        achievements: '',
        generalFeedback: '',
        reviewerComments: '',
        employeeComments: '',
        categories: [
          { name: 'Job Knowledge', rating: 0, comments: '' },
          { name: 'Quality of Work', rating: 0, comments: '' },
          { name: 'Soft Skills', rating: 0, comments: '' },
          { name: 'Initiative', rating: 0, comments: '' }
        ],
        goals: [
          { setGoal: '', progress: '', newGoal: '' }
        ]
      };
    }
  }
};
</script>



<style scoped>
.payroll-view {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}
h1{
  font-weight: bold;
}
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}
input[type="text"] {
    padding: 8px 15px;
    border: 1px solid #ddd;
    border-radius: 20px;
    min-width: 250px;
}
.performance-page {
  display: flex;
  flex-direction: column;
}

.content {
  display: flex;
  margin-top: 10px;
}

.employee-list {
  width: 200px;
  border-right: 1px solid #ccc;
  padding: 1rem;
}

.employee-list button {
  width: 100%;
  background: none;
  border: none;
  padding: 0.5rem;
  text-align: left;
  cursor: pointer;
}

.employee-list button.active {
  background-color: #0d6efd;
  color: white;
}

.performance-review {
  flex: 1;
  padding: 1rem;
}



.review-table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
}

.review-table th,
.review-table td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: left;
  vertical-align: top;
}

.review-table input,
.review-table textarea,
.review-table select {
  width: 100%;
  padding: 6px;
  font-size: 1rem;
  box-sizing: border-box;
}

.review-table textarea {
  resize: vertical;
  min-height: 60px;
}

.bg-primary {
  background-color: #0d6efd;
  color: white;
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.action-buttons {
  display: flex;
  gap: 1rem;
}

.download-btn,
.new-review-btn,
.submit-btn {
  padding: 0.6rem 1rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
}

.download-btn {
  background-color: #0d6efd;
  color: white;
}

.download-btn:hover {
  background-color: #084cdf;
}


.submit-btn {
  background-color: #084cdf;
  color: white  ;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.modal-content {
  background: white;
  padding: 2rem;
  max-width: 600px;
  border-radius: 8px;
  box-shadow: 0 0 10px #00000050;
  max-height: 80vh;
  overflow-y: auto;
}

@keyframes fadeColors {
  0% {
    background-color: #007bff;
  }
  33% {
    background-color: #90d5ff;
  }
  66% {
    background-color: #ff69b4;
  }
  100% {
    background-color: #007bff;
  }
}

.modal-content {
  animation: fadeColors 6s infinite ease-in-out;
  padding: 2rem;
  max-width: 600px;
  border-radius: 8px;
  box-shadow: 0 0 10px #00000050;
  max-height: 80vh;
  overflow-y: auto;
  transition: background-color 0.3s ease;
}
.modal-content button {
  background: linear-gradient(45deg, #6f42c1, #ff69b4, #007bff);
  color: white;
  border: none;
  border-radius: 5px;
  padding: 0.6rem 1.2rem;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.2s ease-in-out;
}

.modal-content button:hover {
  transform: scale(1.1);
  box-shadow: 0 0 10px #fff;
}

.leaderboard {
  margin-top: 2rem;
  padding: 1rem;
  background: #f7f9fb;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.leaderboard h2 {
  margin-bottom: 1rem;
  color: #333;
}

.leaderboard-table {
  width: 100%;
  border-collapse: collapse;
}

.leaderboard-table th,
.leaderboard-table td {
  padding: 10px;
  text-align: left;
  border: 1px solid #ccc;
}

.bar-container {
  background: #e0e0e0;
  border-radius: 4px;
  height: 12px;
  width: 100%;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(to right, #00c6ff, #0072ff);
  border-radius: 4px;
  transition: width 0.4s ease;
}

.leaderboard-toggle {
  margin: 1rem 0;
  
}

.leaderboard-toggle button {
  background-color: #2c81b9;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 0.6rem 1.2rem;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.leaderboard-toggle button:hover {
  background-color: #04417a;
}


</style>
