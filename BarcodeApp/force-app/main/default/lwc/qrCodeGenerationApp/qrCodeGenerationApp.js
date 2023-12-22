import { LightningElement } from 'lwc';
import qrcode from './qrcode.js';
import PDF_LIB from '@salesforce/resourceUrl/pdflib';
 import { loadScript } from "lightning/platformResourceLoader"
export default class QrCodeGenerationApp extends LightningElement {
       inputValue='';
       filename = 'Barcode.pdf';
       previewPDF = false;
       showIframe = false;
       showSpinner = false;

      renderedCallback() {
        loadScript(this, PDF_LIB).then(() => {
        }).catch(error => {
            console.error('Error loading pdflib-js library:', error.message);
        });
          }
    
   changeHandler(event){
      this.inputValue=event.target.value;
      console.log('input value is',this.inputValue)
   }

  async createQR(){
        return new Promise((resolve) => {
          let strForGenearationOfQRCode = this.inputValue;
          let qrCodeGenerated = new qrcode(0, 'H');
          qrCodeGenerated.addData(strForGenearationOfQRCode);
          qrCodeGenerated.make();
  
          let svgString = qrCodeGenerated.createSvgTag({});
          let container = this.template.querySelector(".canvas-container");
  
          // Create an image element with the SVG data
          let img = new Image();
          img.src = 'data:image/svg+xml;base64,' + btoa(svgString);
  
          // Draw the image onto the canvas
          let canvas = this.template.querySelector("canvas");
          let ctx = canvas.getContext("2d");
          img.onload = () => {
              ctx.drawImage(img, 0, 0);
              // Resolve the promise once the QR code is fully rendered
              resolve();
          };
  
          // Append canvas to container
          //container.appendChild(canvas);
      });
   }
    async generatePDF(){
        await this.createQR();
        //const { PDFDocument } = window['PDF_LIB'];

        // Create a new page
        const pdfDoc = await PDFLib.PDFDocument.create();
        const page = pdfDoc.addPage();

        // Get the canvas element containing the QR code
        const canvas = this.template.querySelector('canvas');
        const imageData = canvas.toDataURL('image/png');
         console.log('i am image',imageData)
        // Embed the QR code image in the PDF
        const qrCodeImage = await pdfDoc.embedPng(imageData);
        const qrCodeDims = qrCodeImage.scale(0.5); // Adjust the scale as needed

        // Draw the QR code on the page
        const { width, height } = page.getSize();
        page.drawImage(qrCodeImage, {
            x: width / 2 - qrCodeDims.width / 2,
            y: height / 2 - qrCodeDims.height / 2,
            width: qrCodeDims.width,
            height: qrCodeDims.height,
        });

        // Save the PDF
        const pdfBytes = await pdfDoc.save();

        // Convert the PDF bytes to a Blob
        const pdfBlob = new Blob([pdfBytes], { type: 'application/pdf' });

        // Convert the Blob to a data URL
        const pdfDataUri = URL.createObjectURL(pdfBlob);
        const link = document.createElement('a');
         link.href = pdfDataUri;
        link.download = 'QR.pdf'; // Specify a download filename
         document.body.appendChild(link);
        link.click();
      document.body.removeChild(link);
    }

    
}
