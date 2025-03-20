# AKS Multi-region deployment

# **Project Overview**

## **Cloud Provider**

* **Azure**

## **Regions**

* Central India  
* US East  
* UK West

## **CI/CD Tool**

* **Jenkins**

## **Application Framework**

* **Java / Maven**

---

## **Directory Structure**

* **Production**: Environment configuration  
* **Applications**: Source code of the application  
* **Kubernetes**: Helm charts and manifest files  
* **Terraform**: Infrastructure as Code (IaC) using Terraform

---

## 

## **Terraform Modules**

### **1\. Network**

* Builds **Resource Groups, VNETs, Subnets, NSG**, and **VNET Peering** across all three regions.  
* Deploys a **Bastion host** in the Central India region.

### **2\. Azure Container Registry (ACR)**

* Creates an **ACR** in the Central India region.

### **3\. AKS Cluster**

* Builds **AKS clusters** in all three regions.

### **4\. Private DNS Zone**

* Links the **Private DNS Zone** of AKS clusters with VNETs in all three regions.

### **5\. Application Gateway**

* Deploys **Application Gateways** in all three regions.  
* Backend is set to the **Internal Load Balancer IP** in the respective regions.

### **6\. Azure Front Door (AFD)**

* Creates **Azure Front Door** (AFD) with backend endpoints set to the **Application Gateway** in all three regions.

### **7\. Static CDN**

* Creates a **CDN** with a backend set to **Storage Account and Blob Storage** for static content.

### **8\. Database**

* Deploys **PostgreSQL** in the **Central India** region with read replicas in **US East** and **UK West**.  
* Links the **Private DNS Zone** with the VNET of all regions.

---

## **Jenkins Pipeline Stages**

1. **Checkout**: Clone the source code repository.  
2. **Terraform Build**: Deploy infrastructure using Terraform.  
3. **Maven Test**: Execute unit tests for the application.  
4. **SonarCloud Scan**: Perform code analysis and enforce quality gates.  
5. **Build Artifact**: Generate the application artifact from the source code.  
6. **Docker Image**: Containerize the application using Docker.  
7. **Push Image to ACR**: Upload the container image to Azure Container Registry.  
8. **Modify Configurations**: Update Helm charts and other manifests to align with the latest build.  
9. **Push Helm Chart to ACR**: Store the Helm chart in ACR.  
10. **Sync Config**: Synchronize manifest files and configurations to the Bastion host.  
11. **Deployment**: Deploy essential components, including:  
    * **Ingress Controller**  
    * **ArgoCD Cluster**  
    * **Argo Rollouts**  
    * **Prometheus & Grafana Cluster**

---

## **Installation Steps**

1. **Create a Jenkins Pipeline** using the `Jenkinsfile` in the root directory.  
2. **Configure necessary credentials** in Jenkins using the appropriate plugins.  
3. **Run the Pipeline** and wait for the process to complete.  
4. Once completed, all clusters will be up and running, with the following dashboards accessible via the **Bastion Host IP and Port**:  
   * **Grafana**  
   * **Prometheus**  
   * **ArgoCD** (Default credentials apply)  
5. **Connect ArgoCD to the repository** from the ArgoCD dashboard.  
6. **Deploy the application** using the manifest files located in `kubernetes/maven`.

