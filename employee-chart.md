Here’s a **Markdown employee chart** (org chart / staffing structure) derived from the attachment, formatted cleanly for GitHub:

```markdown
# 📌 Employee Chart

## 👨‍💻 Technical Support Team

### Ketua Pasukan Sokongan Teknikal (Technical Support Team Lead)
- **Headcount:** 1 person  
- **Academic Qualification:** Bachelor's Degree in IT or equivalent  
- **Professional Certification:** AWS / Azure / Google Cloud Certified Developer  
- **Experience:**
  - > 8 years developing ICT systems and/or integration
  - > 3 years developing databases in cloud computing environments  
- **Compliance Documents:** CV and highest academic certificate  

### Ahli Pasukan Sokongan Teknikal (Technical Support Team Member)
- **Headcount:** ≥ 2 persons  
- **Academic Qualification:** Diploma in IT or equivalent  
- **Professional Certification:** Optional  
- **Experience:**
  - ≥ 3 years in ICT system development  
- **Compliance Documents:** CV and highest academic certificate  

---

## 🗄️ Data Management Team

### Pentadbir Pangkalan Data (Database Administrator)
- **Headcount:** 1 person  
- **Academic Qualification:** Bachelor's Degree in IT or equivalent  
- **Professional Certification:** Oracle / MySQL / PostgreSQL / Microsoft SQL Certified  
- **Experience:**
  - > 8 years developing ICT systems and/or integration
  - > 3 years database development in cloud computing environments  
- **Compliance Documents:** CV and highest academic certificate  

---

## 🔄 Change Management Team

### Ketua Pasukan Pengurusan Perubahan (Change Management Team Lead)
- **Headcount:** 1 person  
- **Academic Qualification:** Bachelor's Degree  
- **Professional Certification:** PROSCI Change Management  
- **Experience:**
  - ≥ 5 years managing technology transitions and organizational process change  
- **Compliance Documents:** CV and highest academic certificate  
```

This structure is **hierarchical and modular**, making it easy to push into a GitHub repo for documentation or tender compliance.

👉 Do you want me to also create a **Mermaid diagram (org chart style)** in Markdown so that GitHub renders a **visual hierarchy** of these roles?


Perfect 👍 Here’s the **Mermaid diagram** in Markdown that you can drop into your GitHub `README.md` or any `.md` doc. GitHub will render this as a **visual org chart**.

````

````markdown
# 📊 Employee Org Chart

```mermaid
flowchart TD
    A[👨‍💻 Technical Support Team] --> B[Ketua Pasukan Sokongan Teknikal\n(1 person)]
    B --> C[Ahli Pasukan Sokongan Teknikal\n(≥ 2 persons)]

    A2[🗄️ Data Management Team] --> D[Pentadbir Pangkalan Data\n(1 person)]

    A3[🔄 Change Management Team] --> E[Ketua Pasukan Pengurusan Perubahan\n(1 person)]
````

```

---

### ✅ Rendered Structure

- **Technical Support Team**
  - Team Lead (1)
    - Team Members (≥2)
- **Data Management Team**
  - Database Administrator (1)
- **Change Management Team**
  - Change Management Lead (1)

---

Would you like me to also **embed qualifications & certifications** inside the Mermaid diagram nodes (so the chart itself shows AWS/Oracle/PROSCI etc.), or keep them in the **text sections** for readability?
```
