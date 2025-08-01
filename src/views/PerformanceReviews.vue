<template>
  <div class="payroll-view">
    <div class="header">
      <h1>Performance Review</h1>
      <div class="header-actions">
        <input type="text" placeholder="Search employees..." v-model="searchQuery">
      </div>
    </div>
  </div>
  <div class="performance-page">
    <div class="content">
      <aside class="employee-list">
        <h3>Select an Employee</h3>
        <ul>
          <li v-for="emp in filteredEmployees" :key="emp.id">
            <button
              :class="{ active: emp.id === employee?.id }"
              @click="selectEmployee(emp)"
            >
              {{ emp.name }}
            </button>
          </li>
        </ul>
        <div v-if="isLoading" class="loading">Loading employees...</div>
        <div v-if="error" class="error">{{ error }}</div>
        <p v-if="!isLoading && employees.length === 0">No employees found.</p>
      </aside>

      <div class="main-section animate__animated animate__fadeInUp">
        <div class="header-actions" style="margin-bottom: 1rem;">
          <div class="action-buttons">
            <button @click="showLeaderboard = !showLeaderboard" style="background-color: #2c81b9; color: white; border-radius: 5px; padding: 0.6rem 1.2rem; font-weight: bold;">
              {{ showLeaderboard ? "Hide Leaderboard" : "Show Leaderboard" }}
            </button>
          </div>
        </div>

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
                <td>{{ emp.displayOverallRating || 'N/A' }}</td>
                <td>
                  <div class="bar-container">
                    <div
                      class="bar-fill"
                      :style="{ width: (emp.overallRatingValue * 20) + '%' }"
                    ></div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </section>

        <section class="performance-review animate__animated animate__fadeIn" v-if="employee" ref="reviewSection">
          <div class="header-actions">
            <h2>{{ employee.name || 'New Employee' }} — Performance Review</h2>
            <div class="action-buttons">
              <button @click="generatePDF" class="download-btn">📄 Download PDF</button>
              <button @click="startNewReview(employee.id)" class="new-review-btn btn btn-secondary">➕ Add New Review</button>
              <button v-if="review.review_id" @click="deleteReview(review.review_id)" class="btn btn-sm btn-danger">🗑️ Delete Review</button>
            </div>
          </div>

          <h3>Review Information</h3>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Employee ID</th>
                <th>Department</th>
                <th>Reviewer</th>
                <th>Review Date</th>
                <th>Overall Rating</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>{{ employee.id }}</td>
                <td>{{ employee.department || 'N/A' }}</td>
                <td><input v-model="review.reviewer_name" placeholder="Reviewer Name" /></td>
                <td><input v-model="review.review_date" type="date" /></td>
                <td>
                  <select v-model="review.overall_rating_string">
                    <option v-for="rating in ratingOptions" :key="rating" :value="rating">{{ rating }}</option>
                  </select>
                </td>
              </tr>
            </tbody>
          </table>

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
                <td><textarea v-model="review.achievements" placeholder="Employee achievements" /></td>
                <td><textarea v-model="review.general_feedback" placeholder="General feedback" /></td>
              </tr>
            </tbody>
          </table>

          <h3>Category Review</h3>
          <button @click="addCategory" class="add-category-btn">+ Add Category</button>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Category</th>
                <th>Rating</th>
                <th>Comments</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(cat, index) in review.categories" :key="cat.category_id || 'new-cat-' + index">
                <td>
                  <select v-model="cat.category_name">
                    <option v-for="category in availableCategories" :key="category.category_id" :value="category.category_name">
                      {{ category.category_name }}
                    </option>
                  </select>
                </td>
                <td>
                  <select v-model.number="cat.rating">
                    <option v-for="n in 5" :key="n" :value="n">{{ n }}</option>
                  </select>
                </td>
                <td><input v-model="cat.comments" placeholder="Comments for this category" /></td>
                <td>
                  <button @click="removeCategory(index)" class="btn btn-sm btn-danger">Remove</button>
                </td>
              </tr>
              <tr v-if="review.categories.length === 0">
                <td colspan="4" style="text-align: center;">No categories added yet.</td>
              </tr>
            </tbody>
          </table>

          <h3>Goals and Objectives</h3>
          <button @click="addGoal" class="add-goal-btn">+ Add Goal</button>
          <table class="review-table">
            <thead class="bg-primary">
              <tr>
                <th>Set Goal</th>
                <th>Progress</th>
                <th>New Goal</th>
                <th>Status</th>
                <th>Deadline</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(goal, index) in review.goals" :key="goal.goal_id || 'new-goal-' + index">
                <td><input v-model="goal.set_goal" placeholder="Set Goal" /></td>
                <td><input v-model="goal.progress" placeholder="Progress" /></td>
                <td><input v-model="goal.new_goal" placeholder="Next Goal" /></td>
                <td>
                  <select v-model="goal.status">
                    <option value="not_started">Not Started</option>
                    <option value="in_progress">In Progress</option>
                    <option value="completed">Completed</option>
                    <option value="abandoned">Abandoned</option>
                  </select>
                </td>
                <td><input type="date" v-model="goal.deadline" /></td>
                <td>
                  <button @click="removeGoal(index)" class="btn btn-sm btn-danger">Remove</button>
                </td>
              </tr>
              <tr v-if="review.goals.length === 0">
                <td colspan="6" style="text-align: center;">No goals added yet.</td>
              </tr>
            </tbody>
          </table>

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
                <td><textarea v-model="review.reviewer_comments" placeholder="Reviewer's comments" /></td>
                <td><textarea v-model="review.employee_comments" placeholder="Employee's comments" /></td>
              </tr>
            </tbody>
          </table>

          <div class="footer">
            <button @click="submitReview('completed')" class="submit-btn">Submit Review</button>
          </div>
        </section>
        <div v-else class="no-employee-selected">
            <p>Select an employee from the left panel to view or create a performance review.</p>
        </div>
      </div>
    </div>

    <div v-if="showSuccessModal" class="modal-overlay" @click.self="showSuccessModal = false">
      <div class="modal-content success">
        <h2>Review Submitted Successfully!</h2>
        <p>The performance review has been saved.</p>
        <button @click="showSuccessModal = false" class="btn btn-primary">Close</button>
      </div>
    </div>
  </div>
</template>

<script>
import html2pdf from "html2pdf.js";
import axios from 'axios';

export default {
  name: "PerformanceReviews",
  data() {
    return {
      employees: [],
      employee: null, 
      review: this.getDefaultReview(), 
      searchQuery: '',
      showLeaderboard: false,
      showSuccessModal: false,
      isLoading: false,
      error: null,
      availableCategories: [],
      ratingOptions: ['Outstanding', 'Exceeds Expectations', 'Meets Expectations', 'Needs Improvement', 'Poor'],
    };
  },
  computed: {
    filteredEmployees() {
      const query = this.searchQuery.toLowerCase();
      if (!this.employees || !Array.isArray(this.employees)) {
          return [];
      }
      if (!query) return this.employees;
      return this.employees.filter(emp =>
        emp.name.toLowerCase().includes(query) ||
        (emp.jobTitle && emp.jobTitle.toLowerCase().includes(query)) ||
        (emp.department && emp.department.toLowerCase().includes(query))
      );
    },
    sortedEmployees() {
      if (!this.employees || !Array.isArray(this.employees)) {
          return [];
      }
      return [...this.employees].sort((a, b) => {
        const ratingA = a.overallRatingValue || 0;
        const ratingB = b.overallRatingValue || 0;
        return ratingB - ratingA;
      });
    }
  },
  async created() {
    await this.fetchEmployees();
    await this.fetchCategories();
    if (this.employees.length > 0) {
      await this.fetchReviews();
      if (!this.employee && this.employees.length > 0) {
        this.selectEmployee(this.employees[0]);
      }
    }
  },
  methods: {
    getDefaultReview() {
      return {
        review_id: null,
        employee_id: null,
        reviewer_id: 1, 
        reviewer_name: '',
        review_date: new Date().toISOString().split('T')[0], 
        overall_rating_string: 'Meets Expectations', 
        achievements: '',
        general_feedback: '',
        reviewer_comments: '',
        employee_comments: '',
        status: 'pending', 
        categories: [], 
        goals: [] 
      };
    },
    
    getRatingValueForDisplay(ratingString) {
      const ratingsMap = {
        'Outstanding': 5,
        'Exceeds Expectations': 4,
        'Meets Expectations': 3,
        'Needs Improvement': 2,
        'Poor': 1,
      };
      return ratingsMap[ratingString] || 0; 
    },
    getRatingString(ratingValue) {
        const ratingsMap = {
            5: 'Outstanding',
            4: 'Exceeds Expectations',
            3: 'Meets Expectations',
            2: 'Needs Improvement',
            1: 'Poor'
        };
        return ratingsMap[ratingValue] || 'N/A';
    },
    async fetchEmployees() {
      this.isLoading = true;
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/employee`); 
        this.employees = response.data.map(emp => ({
          ...emp,
          displayOverallRating: 'N/A', 
          overallRatingValue: 0 
        }));
      } catch (error) {
        this.error = error.response?.data?.message || error.message;
        console.error('Error fetching employees:', error);
        this.employees = []; 
      } finally {
        this.isLoading = false;
      }
    },
    async fetchCategories() {
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/categories`);
        this.availableCategories = response.data;
      } catch (error) {
        console.error('Error fetching categories:', error);
        this.availableCategories = [];
      }
    },
    async fetchReviews() {
      this.isLoading = true;
      this.error = null;
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/reviews`);
        const reviews = response.data;

        this.employees.forEach(employee => {
          const review = reviews.find(r => r.employee_id === employee.id);
          if (review) {
            employee.review = review;
            employee.displayOverallRating = this.getRatingString(review.overall_rating);
            employee.overallRatingValue = review.overall_rating; 
          } else {
            employee.review = null;
            employee.displayOverallRating = 'N/A';
            employee.overallRatingValue = 0;
          }
        });

      } catch (error) {
        this.error = error.response?.data?.message || error.message;
        console.error('Error fetching reviews:', error);
      } finally {
        this.isLoading = false;
      }
    },
    async selectEmployee(emp) {
      this.employee = emp;
      this.error = null; 

      if (emp.review && emp.review.review_id) { 
        try {
          const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/reviews/${emp.review.review_id}`);
          const fetchedReview = response.data;

          this.review = {
            review_id: fetchedReview.review_id,
            employee_id: fetchedReview.employee_id,
            reviewer_id: fetchedReview.reviewer_id,
            reviewer_name: fetchedReview.reviewer_name || '',
            review_date: fetchedReview.review_date ? new Date(fetchedReview.review_date).toISOString().slice(0, 10) : new Date().toISOString().slice(0, 10),
            overall_rating_string: this.getRatingString(fetchedReview.overall_rating),
            achievements: fetchedReview.achievements || '',
            general_feedback: fetchedReview.general_feedback || '',
            reviewer_comments: fetchedReview.reviewer_comments || '',
            employee_comments: fetchedReview.employee_comments || '',
            status: fetchedReview.status || 'pending',
            categories: fetchedReview.categories || [], 
            goals: fetchedReview.goals ? fetchedReview.goals.map(g => ({
                ...g,
                deadline: g.deadline ? new Date(g.deadline).toISOString().slice(0, 10) : '' 
            })) : [] 
          };
        }
        catch (error) {
          this.error = error.response?.data?.message || error.message;
          console.error('Error fetching single review for edit, falling back to cached data:', error);
          
          const fallbackReview = { ...emp.review };
          this.review = {
            review_id: fallbackReview.review_id,
            employee_id: fallbackReview.employee_id,
            reviewer_id: fallbackReview.reviewer_id,
            reviewer_name: fallbackReview.reviewer_name || '',
            review_date: fallbackReview.review_date ? new Date(fallbackReview.review_date).toISOString().slice(0, 10) : new Date().toISOString().slice(0, 10),
            overall_rating_string: this.getRatingString(fallbackReview.overall_rating),
            achievements: fallbackReview.achievements || '',
            general_feedback: fallbackReview.general_feedback || '',
            reviewer_comments: fallbackReview.reviewer_comments || '',
            employee_comments: fallbackReview.employee_comments || '',
            status: fallbackReview.status || 'pending',
            categories: fallbackReview.categories || [],
            goals: fallbackReview.goals ? fallbackReview.goals.map(g => ({
                ...g,
                deadline: g.deadline ? new Date(g.deadline).toISOString().slice(0, 10) : ''
            })) : []
          };
        }
      } else {
        // Start a new review for this employee
        this.review = this.getDefaultReview();
        this.review.employee_id = emp.id;
        this.review.reviewer_name = ''; // Clear reviewer name for new review
      }
    },
    filterPayroll() {
    
    },
    addCategory() {
      this.review.categories.push({
        category_id: null, // Indicates a new category
        category_name: this.availableCategories[0]?.category_name || '',
        rating: 3,
        comments: ''
      });
    },
    removeCategory(index) {
      this.review.categories.splice(index, 1);
    },
    addGoal() {
      this.review.goals.push({
        goal_id: null, // Indicates a new goal
        set_goal: '',
        progress: '',
        new_goal: '',
        status: 'not_started', // Default to backend ENUM
        deadline: new Date().toISOString().slice(0, 10)
      });
    },
    removeGoal(index) {
      this.review.goals.splice(index, 1);
    },
    async submitReview(status) {
      if (!this.employee || !this.employee.id) {
        alert('Please select an employee before submitting a review.');
        return;
      }

      // Prepare categories and goals, setting existing IDs only if they are not new items
      const categoriesToSend = this.review.categories.map(cat => ({
        // Only send category_id if it exists (meaning it's an existing category being updated)
        ...(cat.category_id && { category_id: cat.category_id }),
        category_name: cat.category_name,
        rating: cat.rating,
        comments: cat.comments
      }));

      const goalsToSend = this.review.goals.map(goal => ({
        // Only send goal_id if it exists
        ...(goal.goal_id && { goal_id: goal.goal_id }),
        set_goal: goal.set_goal,
        progress: goal.progress,
        new_goal: goal.new_goal,
        status: goal.status,
        deadline: goal.deadline
      }));

      const reviewPayload = {
        employee_id: this.employee.id,
        reviewer_id: this.review.reviewer_id, // Hardcoded for now, should come from auth
        reviewer_name: this.review.reviewer_name,
        review_date: this.review.review_date || new Date().toISOString().split('T')[0],
        overall_rating: this.review.overall_rating_string, // Send the ENUM string directly
        achievements: this.review.achievements,
        general_feedback: this.review.general_feedback,
        reviewer_comments: this.review.reviewer_comments,
        employee_comments: this.review.employee_comments,
        status: status, // 'draft' or 'completed'
        categories: categoriesToSend,
        goals: goalsToSend
      };

      try {
        if (this.review.review_id) {
          // Update existing review
          await axios.put(`${process.env.VUE_APP_API_BASE_URL}/reviews/${this.review.review_id}`, reviewPayload);
          alert('Review updated successfully!');
        } else {
          // Create new review
          await axios.post(`${process.env.VUE_APP_API_BASE_URL}/reviews`, reviewPayload);
          alert('Review created successfully!');
        }
        this.showSuccessModal = true;
        await this.fetchReviews(); // Refresh all reviews and update employee list
        // Re-select the employee to ensure the form updates with the latest saved data
        this.selectEmployee(this.employees.find(emp => emp.id === this.employee.id));

      } catch (error) {
        this.error = error.response?.data?.message || error.message;
        console.error('Review submission error:', error);
        alert(`Failed to submit review: ${this.error}`);
      }
    },
    async deleteReview(reviewId) {
        if (confirm('Are you sure you want to delete this review and all its associated categories and goals? This action cannot be undone.')) {
            try {
                await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/reviews/${reviewId}`);
                alert('Review deleted successfully!');
                await this.fetchReviews(); // Refresh reviews after deletion
                // Find the employee in the local array and clear their review data
                const employeeInList = this.employees.find(emp => emp.id === this.employee.id);
                if (employeeInList) {
                    employeeInList.review = null;
                    employeeInList.displayOverallRating = 'N/A';
                    employeeInList.overallRatingValue = 0;
                }
                this.review = this.getDefaultReview(); // Reset the form
                this.review.employee_id = this.employee.id; // Keep employee ID for potential new review
            } catch (error) {
                this.error = error.response?.data?.message || error.message;
                console.error('Error deleting review:', error);
                alert(`Error: ${this.error}`);
            }
        }
    },
    generatePDF() {
      const element = this.$refs.reviewSection;
      if (!element) {
        alert('Performance review section not found to generate PDF.');
        return;
      }
      const opt = {
        margin: 10,
        filename: `Performance_Review_${this.employee.name}.pdf`,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
      };
      html2pdf().from(element).set(opt).save();
    },
    startNewReview(employeeId) {
      // Find the employee again to ensure we have the latest details
      const selectedEmp = this.employees.find(emp => emp.id === employeeId);
      if (selectedEmp) {
        this.employee = selectedEmp; // Re-select to ensure correct employee context
        this.review = this.getDefaultReview(); // Get a fresh, empty review form
        this.review.employee_id = employeeId; // Associate with the current employee
        this.review.reviewer_name = ''; // Clear reviewer name for new review
      } else {
        alert('Employee not found to start a new review.');
      }
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
  width: 250px; /* Slightly wider for better readability */
  border-right: 1px solid #ccc;
  padding: 1rem;
  background-color: #f8f8f8;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  max-height: 80vh; /* Limit height */
  overflow-y: auto; /* Scrollable */
}

.employee-list ul {
  list-style: none;
  padding: 0;
}

.employee-list li {
  margin-bottom: 5px;
}

.employee-list button {
  width: 100%;
  background: none;
  border: none;
  padding: 0.8rem;
  text-align: left;
  cursor: pointer;
  font-size: 1.1em;
  color: #333;
  border-radius: 5px;
  transition: background-color 0.2s ease, color 0.2s ease;
}

.employee-list button:hover {
  background-color: #e0e0e0;
}

.employee-list button.active {
  background-color: #0d6efd;
  color: white;
  font-weight: bold;
}

.main-section {
  flex: 1;
  padding: 1rem 2rem;
}

.performance-review {
  padding: 1rem;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.no-employee-selected {
    text-align: center;
    padding: 50px;
    color: #666;
    font-size: 1.2em;
    background-color: #f0f0f0;
    border-radius: 8px;
    margin-top: 20px;
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
  border: 1px solid #ddd;
  border-radius: 4px;
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
  flex-wrap: wrap; /* Allow wrapping on smaller screens */
  gap: 10px; /* Space between items */
}

.action-buttons {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.download-btn,
.new-review-btn,
.submit-btn,
.btn-secondary { /* Added for "Save Draft" */
  padding: 0.6rem 1rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.3s ease;
}

.download-btn {
  background-color: #0d6efd;
  color: white;
}

.download-btn:hover {
  background-color: #084cdf;
}

.new-review-btn {
  background-color: #6c757d;
  color: white;
}
.new-review-btn:hover {
  background-color: #5a6268;
}

.submit-btn {
  background-color: #28a745;
  color: white;
}
.submit-btn:hover {
  background-color: #218838;
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
  transition: background-color 0.3s ease; 
}

@keyframes fadeColors {
  0% { background-color: #7ec8e3; }
  33% { background-color: #4fa9d9; }
  66% { background-color: #6A0DAD; }
  100% { background-color: #004953; }
}

.modal-content.success {
  text-align: center;
  animation: fadeColors 6s infinite ease-in-out;
}
.modal-content.success button {
  background: linear-gradient(45deg, #0F0F3D, #004953, #6A0DAD);
  color: white;
  border: none;
  border-radius: 5px;
  padding: 0.6rem 1.2rem;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.2s ease-in-out;
}

.modal-content.success button:hover {
  transform: scale(1.1);
  box-shadow: 0 0 10px #fff;
}


.leaderboard {
  margin-top: 2rem;
  padding: 1.5rem; /* Increased padding */
  background: #f7f9fb;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.leaderboard h2 {
  margin-bottom: 1rem;
  color: #333;
  text-align: center; /* Center leaderboard title */
}

.leaderboard-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
}

.leaderboard-table th,
.leaderboard-table td {
  padding: 12px; /* Increased padding */
  text-align: left;
  border: 1px solid #e0e0e0; /* Lighter border */
}

.leaderboard-table th {
  background-color: #e9ecef; /* Light header background */
  font-weight: bold;
  color: #555;
}

.leaderboard-table tbody tr:nth-child(even) {
  background-color: #fefefe; /* Subtle stripe */
}

.bar-container {
  background: #e0e0e0;
  border-radius: 4px;
  height: 12px;
  width: 100%;
  overflow: hidden; /* Ensure fill doesn't overflow */
}

.bar-fill {
  height: 100%;
  background: linear-gradient(to right, #00c6ff, #0072ff);
  border-radius: 4px;
  transition: width 0.4s ease;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid #3498db;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error {
  padding: 1rem;
  background: #ffebee;
  color: #c62828;
  border-radius: 4px;
  margin: 1rem;
  text-align: center;
}

.add-category-btn, .add-goal-btn {
  background-color: #28a745;
  color: white;
  border: none;
  padding: 8px 16px;
  margin-bottom: 10px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.add-category-btn:hover, .add-goal-btn:hover {
  background-color: #218838;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-danger:hover {
  background-color: #c82333;
}

.footer {
    margin-top: 20px;
    text-align: right;
}
.footer button {
    margin-left: 10px;
}
</style>