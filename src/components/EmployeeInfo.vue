<template>
  <section class="employee-information">
    <h2>Employee Information</h2>
    <div class="info-grid">
      <div class="info-item">
        <label>Employee Name:</label>
        <span>{{ employee.name }}</span>
      </div>
      <div class="info-item">
        <label>Employee ID:</label>
        <span>{{ employee.id }}</span>
      </div>
      <div class="info-item">
        <label>Job Title:</label>
        <span>{{ employee.position }}</span>
      </div>
      <div class="info-item">
        <label>Department:</label>
        <span>{{ employee.department }}</span>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'EmployeeInfo',
  props: {
    employee: {
      type: Object,
      required: true,
      default: () => ({
        id: '',
        name: '',
        position: '',
        department: '',
        employment_history: '',
        contact: ''
      })
    }
  }
};
</script>

<style scoped>
.employee-information {
  padding: 20px;
  border: 1px solid #eee;
  border-radius: 8px;
  margin-bottom: 20px;
}

.employee-information h2 {
  margin-bottom: 20px;
  color: #333;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 15px;
}

.info-item {
  display: flex;
  flex-direction: column;
}

.info-item label {
  font-weight: bold;
  margin-bottom: 5px;
  color: #555;
}

.info-item span {
  padding: 8px;
  background-color: #f8f9fa;
  border-radius: 4px;
}
</style>