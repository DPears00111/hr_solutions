<template>
    <div class="payslip-container" ref="payslipContainer">
        <div class="payslip-header">
            <h2>MODERN TECH SOLUTIONS</h2>
            <h3>PAYSLIP</h3>
            <p>Period: {{ currentPeriod }}</p>
        </div>

        <div class="employee-info">
            <p><strong>Employee ID:</strong> {{ currentEmployee.employeeId }}</p>
            <p><strong>Name:</strong> {{ currentEmployee.name }}</p>
            <p><strong>Position:</strong> {{ currentEmployee.position }}</p>
            <p><strong>Department:</strong> {{ currentEmployee.department }}</p>
        </div>

        <div class="payment-details">
            <div class="earnings">
                <h4>EARNINGS</h4>
                <p>Basic Salary: R{{ Number(currentEmployee.salary || 0).toFixed(2) }}</p>
            </div>
            <div class="deductions">
                <h4>DEDUCTIONS</h4>
                <p>Tax: R{{ (Number(currentEmployee.salary || 0) * 0.15).toFixed(2) }}</p>
            </div>
        </div>

        <div class="net-pay">
            <h3>NET PAY: R{{ (Number(currentEmployee.salary || 0) * 0.85).toFixed(2) }}</h3>
        </div>

    </div>
    <div class="navigation">
        <button @click="prevEmployee" class="nav-btn">Previous</button>
        <button @click="downloadPDF" class="download-btn">Download PDF</button>
        <button @click="nextEmployee" class="nav-btn">Next</button>
    </div>
</template>

<script>
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'

export default {
    name: 'PayrollSlip',
    props: {
        employees: {
            type: Array,
            required: true
        },
        period: {
            type: String,
            default: 'Monthly'
        }
    },
    data() {
        return {
            currentIndex: 0
        }
    },
    computed: {
        currentEmployee() {
            return this.employees[this.currentIndex] || {}
        },
        currentPeriod() {
            const now = new Date()
            return `${now.toLocaleString('default', { month: 'long' })} ${now.getFullYear()}`
        }
    },
    methods: {
        nextEmployee() {
            this.currentIndex = (this.currentIndex + 1) % this.employees.length
        },
        prevEmployee() {
            this.currentIndex = (this.currentIndex - 1 + this.employees.length) % this.employees.length
        },
        async downloadPDF() {
            const element = this.$refs.payslipContainer
            const canvas = await html2canvas(element, {
                scale: 2,
                logging: false,
                useCORS: true
            })

            const pdf = new jsPDF({
                orientation: 'portrait',
                unit: 'mm'
            })

            const imgData = canvas.toDataURL('image/png')
            const imgWidth = 210 // A4 width in mm
            const imgHeight = (canvas.height * imgWidth) / canvas.width

            pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight)
            pdf.save(`payslip_${this.currentEmployee.name.replace(/\s+/g, '_')}.pdf`)
        }
    }
}
</script>

<style scoped>
.payslip-container {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
    border: 1px solid #ddd;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    background-color: white;
}

.payslip-header {
    text-align: center;
    margin-bottom: 20px;
}

.employee-info {
    margin: 20px 0;
    padding: 15px;
    background-color: #f5f5f5;
    border-radius: 5px;
}

.payment-details {
    display: flex;
    justify-content: space-between;
    margin: 20px 0;
}

.earnings,
.deductions {
    width: 48%;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.net-pay {
    text-align: center;
    margin: 20px 0;
    padding: 15px;
    background-color: #599bca;
    color: white;
    border-radius: 5px;
}

.navigation {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.nav-btn,
.download-btn {
    padding: 8px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.nav-btn {
    background-color: #ddd;
}

.download-btn {
    background-color: #599bca;
    color: white;
}

@media print {
    body * {
        visibility: hidden;
    }

    .payslip-container,
    .payslip-container * {
        visibility: visible;
    }

    .payslip-container {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
    }

    .navigation {
        display: none;
    }
}
</style>