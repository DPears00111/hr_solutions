<template>
    <div class="modal-overlay">
        <div class="custom-modal">
            <div class="modal-content rounded-4 shadow">
                <div class="modal-body p-5">
                    <h2 class="fw-bold mb-0">Payroll Details</h2>
                    <ul class="d-grid gap-4 my-5 list-unstyled small">
                        <li><strong>Name:</strong> {{ payrollItem.name }}</li>
                        <li><strong>Department:</strong> {{ payrollItem.department }}</li>
                        <li><strong>Contact:</strong> {{ payrollItem.contact }}</li>
                        <li><strong>Position:</strong> {{ payrollItem.position }}</li>
                    </ul>
                    <button type="button" class="btn btn-lg btn-primary mt-5 w-100" @click="$emit('close')">
                        Great, thanks!
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
export default {
    props: {
        payrollItem: {
            type: Object,
            required: true
        }
    },


    

}
</script>
<style>
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0,0,0,0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
}
.modal-content {
    background-color: rgb(255, 255, 255);
}
.modal-dialog {
    margin: 0 ;
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 0;
}
.custom-modal {
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>
