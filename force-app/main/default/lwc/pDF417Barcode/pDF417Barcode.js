import { LightningElement, wire, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import PDF_LIB from '@salesforce/resourceUrl/pdflib';
import getAttachmentCount from '@salesforce/apex/PDF417BarcodeGenerator.getAttachmentCount';
import getAllFields from '@salesforce/apex/PDF417BarcodeGenerator.getAllSobjectFields';
import getfieldValue from '@salesforce/apex/PDF417BarcodeGenerator.getSelectedFieldValue';
import sendEmailAttachment from '@salesforce/apex/PDF417BarcodeGenerator.sendEmailAttachment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveTheChunkFile from "@salesforce/apex/PDF417BarcodeGenerator.saveTheChunkFile";
import getListOfIds from "@salesforce/apex/PDF417BarcodeGenerator.convertStringtoListId";
import BWIPJS from '@salesforce/resourceUrl/bwipJs';
const MAX_FILE_SIZE = 4500000;
const CHUNK_SIZE = 750000;
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';

export default class TestPDF417Barcode extends NavigationMixin(LightningElement) {
    @api listViewIds;
    @api recordId;
    value;
    showBarcode = false;
    fieldsList = [];
    selectedField;
    alternativeText;
    attachmentCount;
    barcodeSRC;
    showSpinner = false;
    isButton = true;
    sendEmail = false;
    resultValue;
    pdf;
    filename = 'Barcode.pdf';
    previewPDF = false;
    showIframe = false;
    @api accountList;
    @api objectApiName;
    selectedListViewRecords;
    isBwipJsLoaded = false ; //samir code

    @wire(CurrentPageReference) pageRef;

    @api refresh() {
        fireEvent(this.pageRef, 'refresh', this.name);
    }
    get isEmptyAccountList() {
        return !this.accountList || this.accountList.length === 0;
    }
        
   
 async renderedCallback(){
     await Promise.all([loadScript(this, BWIPJS), loadScript(this, PDF_LIB)]).then(() => {
            this.isBwipJsLoaded=true;//samir code
        }).catch(error => {
            console.error('Error loading bwip-js library:', error.message);
        });
				
        if (this.listViewIds != undefined && this.listViewIds != '') {
            getListOfIds({selectedIds: JSON.stringify(this.listViewIds)})
            .then(result => {
                this.accountList = result;
                this.accountList = this.accountList.map((i) => {
                    return {
                        Id: i
                    }
                });
            })
        }
        try {

            this.value = this.options[0].value;
            this.showBarcode = false;
            if (this.accountList && this.listViewIds == undefined && this.listViewIds == '') {
                this.accountList = this.accountList.replace('[', '').replace(']', '').split(',').map((i) => {
                    return {
                        Id: i.trim()
                    }
                });
            }
            
        } catch (error) {
            
        }
    }





   /* Parvinder's code
   async connectedCallback() {
        await Promise.all([loadScript(this, BWIPJS), loadScript(this, PDF_LIB)]).then(() => {
            
        }).catch(error => {
            console.error('Error loading bwip-js library:', error.message);
        });
				
        if (this.listViewIds != undefined && this.listViewIds != '') {
            getListOfIds({selectedIds: JSON.stringify(this.listViewIds)})
            .then(result => {
                this.accountList = result;
                this.accountList = this.accountList.map((i) => {
                    return {
                        Id: i
                    }
                });
            })
        }
        try {

            this.value = this.options[0].value;
            this.showBarcode = false;
            if (this.accountList && this.listViewIds == undefined && this.listViewIds == '') {
                this.accountList = this.accountList.replace('[', '').replace(']', '').split(',').map((i) => {
                    return {
                        Id: i.trim()
                    }
                });
            }
            
        } catch (error) {
            
        }
        
    }*/

    forceRefreshView() {
        // Use the NavigationMixin to refresh the view
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordIdentifier,
                actionName: 'view'
            }
        });
    }

    get options() {
        return [
            { label: 'PDF417', value: 'pdf417' },
            { label: 'EAN8', value: 'ean8' },
            { label: 'CODE128', value: 'code128' },
            { label: 'CODE39', value: 'code39' },
            { label: 'EAN-13', value: 'ean13' },
            { label: 'CODE93', value: 'code93' },
            { label: 'CODE11', value: 'code11' },
            { label: 'CODE25', value: 'code2of5' }
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    handleChangeField(event) {
        this.selectedField = event.detail.value;
        this.isButton = false;
    }

    @wire(getAllFields, { objectApiName: '$recordIdentifier' })
    sobjectFields({ data, error }) {
        if (data) {
            this.fieldsList = data;
            this.selectedField = this.fieldsList[0].value;
        } else if (error) {
            console.error('Error fetching fields:', error);
        }
    }
    get getFieldOptions() {
        return this.fieldsList;
    }
    // Inside the TestPDF417Barcode class
    get isPDF417Format() {
        return this.value === 'pdf417';
    }
    async handleClick() {
        
        if (this.listViewIds != undefined || this.listViewIds == '') {
            this.recordId = null
        }
        this.showSpinner = true;
        this.isButton = true;
        this.showBarcode = true; // Set to true before generating the barcode(s)

        
        if (this.accountList && this.accountList.length) {
            const accountList = this.accountList;
            for (let i = 0; i < accountList.length; i++) {
                accountList[i].resultValue =  await this.getSelectedFieldValue(accountList[i].Id);
                if (!accountList[i].resultValue) {
                    this.showToast('Error', 'Selected field has no value in the record with ID ' + accountList[i].Id, 'error');
                    this.showSpinner = false;
                    return;
                }
            }
            this.accountList = accountList;
        } else {
            this.resultValue = await this.getSelectedFieldValue(); // Generate the barcode
            
            if (!this.resultValue) {
                this.showToast('Error', 'Selected field has no value in the record', 'error');
                this.showSpinner = false;
                return;
            }
        }
        try {
            this.showToast('Success', 'Barcode has generated successfully', 'success');
        } catch (error) {
            console.error('Error generating barcode:', error.message);
        } finally {
            this.showSpinner = false;
        }
    }
    get recordIdentifier() {
        if (this.listViewIds && this.listViewIds.length && this.listViewIds[0]) return this.listViewIds[0];
        if (this.recordId) return this.recordId;
        if (this.accountList && this.accountList.length && this.accountList[0].Id) return this.accountList[0].Id;
        return null;
    }

    async getSelectedFieldValue(barCodeId) {
        
        this.showBarcode = true;
        try {
            const result = await getfieldValue({ fieldApiName: this.selectedField, recId: barCodeId || this.recordIdentifier });
            
            if (result !== '' && result !== undefined) {
                const canvas = barCodeId ? this.template.querySelector(`[data-barcode="${barCodeId}"]`) : this.template.querySelector('.barcode-canvas');
                const opts = {
                    bcid: this.value, // Barcode type (e.g., code128, qrcode, etc.)
                    text: result, // Barcode content
                    scale: 2, // Barcode scale factor (adjust as needed)
                    height: 5, // Barcode height (adjust as needed)
                    includetext: true, // Include human-readable text
                };
                
                try {
                    //my code
                       if(!this.isBwipJsLoaded){
                               console.log('I am getting call samir and loading resources');
                              //now loading resources
                              await Promise.all([loadScript(this, BWIPJS), loadScript(this, PDF_LIB)]).then(() => {
                                this.isBwipJsLoaded=true;
                              }).catch(error => {
                                  console.error('Error loading bwip-js library:', error.message);
                              });
                                      
                              if (this.listViewIds != undefined && this.listViewIds != '') {
                                  getListOfIds({selectedIds: JSON.stringify(this.listViewIds)})
                                  .then(result => {
                                      this.accountList = result;
                                      this.accountList = this.accountList.map((i) => {
                                          return {
                                              Id: i
                                          }
                                      });
                                  })
                              }
                              try {
                      
                                  this.value = this.options[0].value;
                                  this.showBarcode = false;
                                  if (this.accountList && this.listViewIds == undefined && this.listViewIds == '') {
                                      this.accountList = this.accountList.replace('[', '').replace(']', '').split(',').map((i) => {
                                          return {
                                              Id: i.trim()
                                          }
                                      });
                                  }
                                  
                              } catch (error) {
                                  
                              }

                        }

                    //above is samir's code
               
                    bwipjs.toCanvas(canvas, opts, (err, canvas) => {
                        if (err) {
                            console.error('Error generating barcode:', err.message);
                            //reject(err);
                        }
                        // Barcode generated successfully
                    });
                } catch (error) {
     
                    console.error('Error generating barcode:', error.message);
                   
                }
                // Barcode generated successfully
                this.alternativeText = 'test';
                
                if (this.sendEmail || this.previewPDF) {
                    await this.handleSave();
                }
            }
            this.showSpinner = false;
            return result;
        } catch (error) {
            console.error('Error getting field value:', error.message);
        }
    }

    async handleSave() {
        this.showSpinner = true;
        if (!this.sendEmail && !this.previewPDF) {
            // Generate the barcode
            await this.handleClick();

            // Check if the barcode is generated successfully
            if (!this.showBarcode) {
                // Barcode is not generated
                this.showToast('Error', 'Barcode is not generated', 'error');
                this.showSpinner = false;
                return;
            }
        }
        if (this.accountList && this.accountList.length) {
            if (this.previewPDF) {
                const combinedCanvas = document.createElement('canvas');
                const combinedContext = combinedCanvas.getContext('2d');
                combinedCanvas.width = 0;
                combinedCanvas.height = 0;
                for (let i = 0; i < this.accountList.length; i++) {
                    const canvas = this.template.querySelector(`[data-barcode="${this.accountList[i].Id}"]`);
                    combinedContext.drawImage(canvas, combinedCanvas.width, 0);
                    combinedCanvas.width += canvas.width;
                    combinedCanvas.height = Math.max(canvas.height, combinedCanvas.height);
                }
                const imageUri = combinedCanvas.toDataURL('image/png');
                const base64String = imageUri.split(',')[1];
                const blob = this.base64ToBlob(base64String, 'image/png');
                await this.processFilesToConvert(blob);
            } else {
                for (let i = 0; i < this.accountList.length; i++) {
                    const canvas = this.template.querySelector(`[data-barcode="${this.accountList[i].Id}"]`);
                    const imageUri = canvas.toDataURL('image/png');
                    const base64String = imageUri.split(',')[1];
                    const blob = this.base64ToBlob(base64String, 'image/png');
                    await this.processFilesToConvert(blob, this.accountList[i].Id);
                    if (!this.previewPDF) {
                        setTimeout(() => {
                            this.forceRefreshView();
                        }, 2000);
                    }
                }
            }

        } else {
            const canvas = this.template.querySelector('.barcode-canvas');
            const imageUri = canvas.toDataURL('image/png');
            const base64String = imageUri.split(',')[1];
            const blob = this.base64ToBlob(base64String, 'image/png');
            await this.processFilesToConvert(blob);
            if (!this.previewPDF) {
                setTimeout(() => {
                    this.forceRefreshView();
                }, 2000);
            }
        }

    }

    base64ToBlob(base64Data, contentType) {
        try { 
            const sliceSize = 512;
            const byteCharacters = atob(base64Data);
            const byteArrays = [];

            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                const slice = byteCharacters.slice(offset, offset + sliceSize);
                const byteNumbers = new Array(slice.length);
                for (let i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }
                const byteArray = new Uint8Array(byteNumbers);
                byteArrays.push(byteArray);
            }

            return new Blob(byteArrays, { type: contentType });
        } catch (error) {
            console.error('Error converting blob 1:', error.message);
        }

    }

    async processFilesToConvert(file, recId) {
        try {
           
            var reader = new FileReader();
            var self = this;
            this.fileName = 'Pdf417 Barcode';
            this.filetype = file.type;
            reader.onload = async function () {
                var fileContents = reader.result;
                var base64Mark = "base64,";
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                if (self.filetype != "application/pdf")
                    await self.embedImageFile(fileContents, self.filetype, recId);
            };
            reader.readAsDataURL(file);
        } catch (error) {
            console.error('Error converting image to PDF:', error.message);
        }

    }
    async embedImageFile(file, filetype, recId) {
        try {
            
            const pdfDoc = await PDFLib.PDFDocument.create();
            let imageFile = "";
            if (filetype == "image/png") imageFile = await pdfDoc.embedPng(file);
            else if (filetype == "image/jpeg") imageFile = await pdfDoc.embedJpg(file);

            let imageDims = imageFile;

            const page = pdfDoc.addPage();
            if (imageFile.width > 595) {
                const scaleValue = parseFloat(595 / imageFile.width);
                imageDims = imageFile.scale(scaleValue);
            }
            // Calculate the position for the barcode in the middle of the upper side
            const barcodeWidth = imageDims.width;
            const barcodeHeight = imageDims.height;
            const pageWidth = page.getWidth();
            const pageHeight = page.getHeight();
            const barcodeX = (pageWidth - barcodeWidth) / 8;
            const barcodeY = pageHeight - barcodeHeight - 30; // Adjust the vertical position as needed

            page.drawImage(imageFile, {
                x: barcodeX,
                y: barcodeY,
                width: barcodeWidth,
                height: barcodeHeight
            });
            const pdfBytes = await pdfDoc.save();
            if (this.previewPDF) {
                this.previewPdfFile(pdfBytes);
            }
            else {
                await this.prepareFileToUpload(pdfBytes, recId);
            }
        } catch (error) {
            console.error('Error converting image to PDF:', error.message);
        }

    }

    async prepareFileToUpload(pdfBytes, recId) {
        
        var blob = new Blob([pdfBytes], { type: "application/pdf" });
        this.fileSize = this.formatBytes(blob.size, 2);
        if (blob.size > MAX_FILE_SIZE) {
            let message =
                "File size cannot exceed " +
                MAX_FILE_SIZE +
                " bytes.\n" +
                "Selected file size: " +
                blob.size;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error",
                    message: message,
                    variant: "error"
                })
            );
            return;
        }
        var reader = new FileReader();
        var self = this;
        reader.onload = async function () {
            var fileContents = reader.result;
            var base64Mark = "base64,";
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            if (self.filetype != "application/pdf") await self.upload(blob, fileContents, recId);
            else await self.upload(blob, pdfBytes);
        };
        reader.readAsDataURL(blob);
    }

    async upload(file, fileContents, recId) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
        return this.uploadChunk(file, fileContents, fromPos, toPos, "", recId);
    }
    uploadChunk(file, fileContents, fromPos, toPos, attachId, recId) {
        
        this.isLoading = true;
        var chunk = fileContents.substring(fromPos, toPos);
        if (this.sendEmail) {
            
            this.sendEmail = false;
            sendEmailAttachment({ emailId: this.emailValue, base64Data: chunk, recId: recId || this.recordIdentifier, selectFieldName: this.selectedField, barcodeType: this.value })
                .then(() => {
                    this.showSpinner = false;
                    this.showToast('Success', 'Email has sent successfully on given address', 'success');
                })
                .catch((error) => {
                    this.showSpinner = false;
                    console.error('Error sending email:', error);
                    this.showToast('Error', 'Failed to send email', 'error');
                });

        } else {
            saveTheChunkFile({
                parentId: recId || this.recordIdentifier,
                fileName: file.name,
                base64Data: encodeURIComponent(chunk),
                contentType: file.type,
                fileId: attachId,
                fieldName: this.selectedField,
                barcodeVer: this.value
            })
                .then((result) => {
                    this.showSpinner = false;
                    attachId = result;
                    fromPos = toPos;
                    toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
                    if (fromPos < toPos) {
                        this.uploadChunk(file, fileContents, fromPos, toPos, attachId);
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: "Success!",
                                message: "File save as a pdf in notes & attachment Successfully",
                                variant: "success"
                            })
                        );
                        setTimeout(() => this.showSpinner = false, 2000);
                        //setTimeout(() => this.previewHandler(result), 3000);
                        setTimeout(() => this.forceRefreshView(), 4000); // Refresh the page
                    }
                })
                .catch((error) => {
                    console.error("Error: ", error);
                })
                .finally(() => { });
        }
    }
    previewHandler(recId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: recId
            }
        })
    }

    base64ToUint8Array(base64String) {
        const raw = atob(base64String);
        const uint8Array = new Uint8Array(raw.length);
        for (let i = 0; i < raw.length; i++) {
            uint8Array[i] = raw.charCodeAt(i);
        }
        return uint8Array;
    }
    formatBytes(bytes, decimals) {
        if (bytes == 0) return "0 Bytes";
        var k = 1024,
            dm = decimals || 2,
            sizes = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"],
            i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + " " + sizes[i];
    }
    emailValue = '';
    isEmailButtonDisabled = true;

    handleEmailChange(event) {
        this.emailValue = event.target.value.toLowerCase();
        this.isEmailButtonDisabled = !this.validateEmail(event.target.value);
    }

    validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    arrayBufferToBase64(buffer) {
        let binary = '';
        const bytes = new Uint8Array(buffer);
        for (let i = 0; i < bytes.byteLength; i++) {
            binary += String.fromCharCode(bytes[i]);
        }
        return btoa(binary);
    }
    async handleSendEmail() {
        if (!this.validateEmail(this.emailValue)) {
            this.showToast('Error', 'Please enter a valid email address', 'error');
            return;
        }
        this.sendEmail = true;
        this.previewPDF = false;
        this.showSpinner = true;

        try {
            const accountList = this.accountList || [];
            const isMultipleRecords = accountList.length > 1; // Check if it's multiple records
            const barcodeData = isMultipleRecords
                ? await Promise.all(accountList.map((account) => this.getSelectedFieldValue(account.Id)))
                : await this.getSelectedFieldValue(); // For single record, directly get the barcodeData

            if (isMultipleRecords) {
                this.sendEmail = false;
            }

            // Create a new PDF document
            const pdfDoc = await PDFLib.PDFDocument.create();
            const page = pdfDoc.addPage();

            // Define the barcode size and position
            const barcodeWidth = 200;
            const barcodeHeight = 30;
            const xMargin = 40;
            let yMargin = page.getHeight() - barcodeHeight - 20;

            // Add each barcode to the single page in the PDF
            for (let i = 0; i < barcodeData.length; i++) {
                const barcodeValue = barcodeData[i];
                const barcodeId = isMultipleRecords ? accountList[i].Id : this.account.Id; // Pass id for single record
                const canvas = isMultipleRecords
                    ? this.template.querySelector(`[data-barcode="${barcodeId}"]`)
                    : this.template.querySelector('.barcode-canvas'); // Use '.barcode-canvas' for single record
                const barcodeImageUri = canvas.toDataURL('image/png');
                const barcodeImage = await pdfDoc.embedPng(barcodeImageUri);
                page.drawImage(barcodeImage, { x: xMargin, y: yMargin, width: barcodeWidth, height: barcodeHeight });

                // Adjust the y-coordinate for the next barcode (stacking them vertically)
                yMargin -= barcodeHeight + 10; // Add some spacing between stacked barcodes
            }

            // Save the complete PDF document
            const pdfBytes = await pdfDoc.save();

            // Convert the PDF bytes to base64 format
            const base64PDF = this.arrayBufferToBase64(pdfBytes);

            // Send the email with the PDF attachment
            await this.sendEmailWithAttachment(this.emailValue, base64PDF);

            this.showToast('Success', 'Email sent successfully', 'success');
            setTimeout(() => this.forceRefreshView(), 2000); // Refresh the page after a delay
        } catch (error) {
            console.error('Error generating barcode or sending email:', error.message);
        } finally {
            this.showSpinner = false;
        }
    }
    async sendEmailWithAttachment(emailValue, base64PDF) {
        try {
            await sendEmailAttachment({
                emailId: emailValue,
                base64Data: base64PDF,
                recId: this.recordIdentifier,
                selectFieldName: this.selectedField,
                barcodeType: this.value
            });
        } catch (error) {
            console.error('Error sending email:', error);
            this.showToast('Error', 'Failed to send email', 'error');
        }
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
    async handleGenerateBarcodePDF() {
        try {
            this.previewPDF = true;
            this.handleClick();

            // Wait for all barcodes to be generated
            await Promise.all(this.accountList.map((account) => this.getSelectedFieldValue(account.Id)));

            // Create a new PDF document
            const pdfDoc = await PDFLib.PDFDocument.create();
            const page = pdfDoc.addPage();

            // Define the barcode size and position
            const barcodeWidth = 200;
            const barcodeHeight = 30;
            const xMargin = 40;
            const yMargin = page.getHeight() - barcodeHeight - 20; // Set yMargin to the top of the page

            let x = xMargin;
            let y = yMargin;

            // Add each barcode to the single page in the PDF
            for (const account of this.accountList) {
                const barcodeImageUri = this.template.querySelector(`[data-barcode="${account.Id}"]`).toDataURL('image/png');
                const barcodeImage = await pdfDoc.embedPng(barcodeImageUri);
                page.drawImage(barcodeImage, { x, y, width: barcodeWidth, height: barcodeHeight });

                // Adjust the y-coordinate for the next barcode (stacking them vertically)
                y -= barcodeHeight + 10; // Add some spacing between stacked barcodes
            }

            // Save the complete PDF document
            const pdfBytes = await pdfDoc.save();

            // Display the PDF to the user
            this.previewPdfFile(pdfBytes);
        } catch (error) {
            console.error('Error generating barcode:', error.message);
        }
    }
    base64ToBlob(base64Data, contentType) {
        const byteCharacters = atob(base64Data);
        const byteArrays = [];
        for (let offset = 0; offset < byteCharacters.length; offset += 512) {
            const slice = byteCharacters.slice(offset, offset + 512);
            const byteNumbers = new Array(slice.length);
            for (let i = 0; i < slice.length; i++) {
                byteNumbers[i] = slice.charCodeAt(i);
            }
            const byteArray = new Uint8Array(byteNumbers);
            byteArrays.push(byteArray);
        }
        return new Blob(byteArrays, { type: contentType });
    }

    get pdfSrc() {
        return this.pdf;
    }

    previewPdfFile(base64Chunk) {
        this.showSpinner = false;
        const pdfBlob = new Blob([base64Chunk], { type: 'application/pdf' });
        this.pdf = URL.createObjectURL(pdfBlob);
        window.open(this.pdf, '_blank');
        this.previewPDF = false;
    }
}