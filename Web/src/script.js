const listContainer = document.getElementById("list-container")
const addTaskButton = document.getElementById('addTaskButton');
const taskForm = document.getElementById('taskForm');
const submitFormButton = document.getElementById('submitFormButton');
const appBody = document.getElementById("appBody");
const markAllButton = document.getElementById("markAllButton");
const deleteCompletedButton = document.getElementById("deleteAllMarkedButton");
const taskFilter = document.getElementById('taskFilter');
const closeFormButton = document.getElementById('closeFormButton');
const buttonsSection = document.getElementById('buttonSection');


function validateTask(taskTitle, dueDate) {
    
    if(dueDate){
        var parsedDate = new Date(dueDate);
        var currentDate = new Date();

    // Compare the dates
        if (parsedDate <= currentDate) {
        
            alert('Due date must be after the current date.');
        
            return false; 
        }
    }
    // If the due date is valid or isn't specified, the form is valid
    return true;
}

function closeForm(){
    taskForm.reset();
    taskForm.style.display = 'none';
    taskForm.setAttribute("aria-hidden", "true");
    buttonsSection.style.display = 'flex';
    buttonsSection.setAttribute("aria-hidden", "false");
    if(listContainer.style.display = 'none'){
        listContainer.style.display = 'flex';
        listContainer.setAttribute("aria-hidden", "false");
    }
    showAll();
}

function toggleDescription(button) {
    const task = button.parentElement;
    const taskDescription = task.querySelector('.taskDescription');
    button.classList.toggle('active');
    if (taskDescription.style.maxHeight) {
      taskDescription.style.maxHeight = null;
      task.setAttribute("aria-expanded", false);
      this.setAttribute("aria-label", "show long description");
      
    } else {
      taskDescription.style.maxHeight = taskDescription.scrollHeight + 'px'; // Set your desired height here
      task.setAttribute("aria-expanded", true);
      this.setAttribute("aria-label", "hide long description");
    }
}

function addTask(){
    const taskTitle = document.getElementById('taskTitle').value;
    const longDescription = document.getElementById('longDescription').value;
    const dueDate = document.getElementById('dueDate').value;
    
    if(taskTitle.trim === ''){
        const titleError = getElementById('titleError');
        titleError.style.display = "block";
    }
    else{
        titleError.style.display = "none";
        // Create a new task item
        var taskItem = document.createElement('li');
        var titleField = document.createElement('span');
        titleField.textContent = taskTitle;
        titleField.classList.add("taskContent");
        taskItem.appendChild(titleField);

        if (dueDate) {
            var dateField = document.createElement('p');

            const parsedDate = new Date(dueDate);
            const formattedDate = `${parsedDate.toLocaleDateString()} ${parsedDate.toLocaleTimeString()}`;
            dateField.classList.add("taskContent");
            dateField.textContent = `Limit: ${formattedDate}`;

            taskItem.appendChild(dateField);
        }

        if (longDescription.trim() !== '') {
            const descriptionField = document.createElement('section');
            descriptionField.classList.add('taskDescription');
            descriptionField.classList.add("taskContent");
            descriptionField.innerHTML = `<p>${longDescription}</p>`;

            const showMoreBtn = document.createElement('button');
            showMoreBtn.classList.add('expandButton');
            showMoreBtn.setAttribute("aria-label", "show long description");

            taskItem.appendChild(descriptionField);
            taskItem.appendChild(showMoreBtn);
            taskItem.setAttribute("aria-expanded", false);
        }

        let deleteBtn = document.createElement("button");
        deleteBtn.classList.add('delete');
        deleteBtn.innerText = "\u00d7";
        deleteBtn.setAttribute("aria-label", "delete task")
        taskItem.appendChild(deleteBtn);
        taskItem.setAttribute("role", "listitem");

        // Add the task to the list
        listContainer.appendChild(taskItem);
        saveData();
        closeForm();
    }
}

closeFormButton.addEventListener('click', function () {
    closeForm();
})


addTaskButton.addEventListener('click', function () {
        // Toggle the visibility of the list and form sections
        buttonsSection.style.display = 'none';
        buttonsSection.setAttribute("aria-hidden", "true");
        if(window.innerWidth < 780){
            listContainer.style.display = 'none';
            listContainer.setAttribute("aria-hidden", "true");
        }
        taskForm.style.display = 'flex';
        taskForm.setAttribute("aria-hidden", "false");
        const dateInput = document.getElementById('dueDate');
});


taskForm.addEventListener('submit', function (event) {
        addTask();
        event.preventDefault();
});

listContainer.addEventListener("click", function(e){
    if(e.target.classList.contains('expandButton')){
        toggleDescription(e.target);
    }
    else if (e.target.classList.contains('delete')){
        e.target.parentElement.remove();
        saveData();
    }
    else{
        e.target.classList.toggle("checked");
        saveData();
    }
}, false);

function saveData(){
   localStorage.setItem("data", listContainer.innerHTML); 
}

function showTask(){
    listContainer.innerHTML = localStorage.getItem("data");
}

showTask();

markAllButton.addEventListener("click", function () {
    markAll();
});

deleteCompletedButton.addEventListener("click", function () {
    deleteCompleted();
});

function markAll() {
    const tasks = document.querySelectorAll("#list-container li");
    tasks.forEach(task => {
        task.classList.add("checked");
    });
    saveData();
}

function deleteCompleted() {
    const completedTasks = document.querySelectorAll("#list-container li.checked");
    completedTasks.forEach(task => {
        task.remove();
    });
    saveData();
}



function showCompleted(){
    const tasksCompleted = document.querySelectorAll("#list-container li");
    tasksCompleted.forEach(task => {
        if (!task.classList.contains('checked')) {
            task.style.display = "none";
          }else{
            task.style.display = "block";
          }

    });
    saveData();
}

function showNonCompleted(){
    const tasksNonCompleted = document.querySelectorAll("#list-container li");
    tasksNonCompleted.forEach(task => {
        if (task.classList.contains('checked')) {
            task.style.display = "none";
          }else{
            task.style.display = "block";
          }
    });
    saveData();
}

function showAll(){
    const tasksNonCompleted = document.querySelectorAll("#list-container li");
    tasksNonCompleted.forEach(task => {
            task.style.display = "block";
    });
    saveData();
}

taskFilter.addEventListener('click', function () {
    this.setAttribute("aria-expanded", true);
  });

taskFilter.addEventListener('change', function () {
    switch(this.value){
        case "all":
            showAll();
            break;
        case "completed":
            showCompleted();
            break;
        case "active":
            showNonCompleted()
            break;
    this.setAttribute("aria-expanded", false);
    }
  });
