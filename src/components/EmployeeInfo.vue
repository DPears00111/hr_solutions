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
        <span>{{ employee.jobTitle }}</span>
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
      required: true
    }
  }
}
</script>

<style scoped>
/* Add styling here */
</style>

