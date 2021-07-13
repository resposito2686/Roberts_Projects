using System;
class Project4
{
    public static void Main(string[] args)
    {
        /************* INITIALIZATION *****************************
         * Initializes the main memory and page tables arrays, the
         * experiment statistics, and the variables used in the
         * program.
         *********************************************************/
        MemoryEntry[] mainMemory = new MemoryEntry[32];
        PageTableEntry[,] pageTables = new PageTableEntry[10, 128];
        int pageFaults = 0;
        int diskRef = 0;
        int dirtyWrites = 0;
        int memLocation = 0;
        bool memFull = false;
        string algorithm = null;

        /*** Random Replacement Variables ***/
        Random rand = new Random();

        /*** LRU Replacement Variables ***/
        int[] lruCount = new int[mainMemory.Length];
        int largestReference;

        for (int i = 0; i < mainMemory.Length; i++)
        {
            mainMemory[i] = null;
            lruCount[i] = 0;
        }

        for (int i = 0; i < 10; i++)
        {
            for (int j = 0; j < 128; j++)
            {
                pageTables[i, j] = null;
            }
        }

        /******************* FILE PARSING **********************
         * Uses a StreamReader to parse the data from the file.
         * Data is divided into process, vpn, and operation
         * variables.
         * 
         * NOTE: To used a different file, place it in the
         * Project 4\bin\Debug\netcoreapp3.1 folder, and type
         * the name of the file in the StreamReader arguement.
         *******************************************************/
        System.IO.StreamReader file = new System.IO.StreamReader("data2.txt"); //<--- File name here
        string[] fileData;
        string inputString;
        int process;
        int vpn;
        char operation;

        /******************** MAIN LOOP *************************
         * Executes the experiment. Each iteration of the loop
         * represents one time unit. It will first check if the 
         * requested page table entry is in memory. If it is not, 
         * the entry will be added into main memory and counted 
         * as a page fault. Once main memory is full, the next 
         * page entry that will be replaced is calculated.
         *******************************************************/
        while ((inputString = file.ReadLine()) != null)
        {
            fileData = inputString.Split(' ');
            process = Convert.ToInt32(fileData[0]);
            vpn = Convert.ToInt32(fileData[1]);
            vpn >>= 9;
            operation = Convert.ToChar(fileData[2]);

            for (int i = 0; i < lruCount.Length; i++)
            {
                lruCount[i]++;
            }

            if (pageTables[process, vpn] == null)
            {
                pageFaults++;
                diskRef++;

                if (operation == 'W')
                {
                    pageTables[process, vpn] = new PageTableEntry(memLocation, 1);
                }
                else 
                {
                    pageTables[process, vpn] = new PageTableEntry(memLocation, 0);
                }

                mainMemory[memLocation] = new MemoryEntry(process, vpn);

                /********************************************************************************
                *************************** RANDOM REPLACEMENT *********************************
                if (!memFull)
                {
                    memLocation++;
                    if (memLocation == 31)
                    {
                        memFull = true;
                        algorithm = "Random Replacement";
                    }
                }
                else
                {
                    memLocation = rand.Next(31);
                    process = mainMemory[memLocation].getProcessNum();
                    vpn = mainMemory[memLocation].getIndex();
                    if (pageTables[process, vpn].getDirtyBit() == 1)
                    {
                        diskRef++;
                    }
                    pageTables[process, vpn] = null;
                }
                /*********************************************************************************
                *********************************************************************************/

                /********************************************************************************
                *************************** FIFO REPLACEMENT ***********************************
                if (!memFull)
                {
                    memLocation++;
                    if (memLocation == 31)
                    {
                        memFull = true;
                        algorithm = "FIFO Replacement";
                    }
                }
                else
                {
                    memLocation++;
                    if (memLocation == 32)
                    {
                        memLocation = 0;
                    }

                    process = mainMemory[memLocation].getProcessNum();
                    vpn = mainMemory[memLocation].getIndex();
                    if (pageTables[process, vpn].getDirtyBit() == 1)
                    {
                        diskRef++;
                    }
                    pageTables[process, vpn] = null;
                }
                /********************************************************************************
                *******************************************************************************/

                /********************************************************************************
                **************************** LRU REPLACEMENT ***********************************

                lruCount[memLocation] = 0;
                if (!memFull)
                {
                    memLocation++;
                    if (memLocation == 31)
                    {
                        memFull = true;
                        algorithm = "LRU Replacement";
                    }
                }
                else
                {
                    largestReference = 0;
                    for (int i = 0; i < lruCount.Length; i++)
                    {
                        if (lruCount[i] > largestReference)
                        {
                            largestReference = lruCount[i];
                            memLocation = i;
                        }
                    }

                    process = mainMemory[memLocation].getProcessNum();
                    vpn = mainMemory[memLocation].getIndex();
                    if (pageTables[process, vpn].getDirtyBit() == 1)
                    {
                        diskRef++;
                    }
                    pageTables[process, vpn] = null;
                }
                /*******************************************************************************
                *******************************************************************************/
            }
            else 
            {
                lruCount[pageTables[process, vpn].getMemLocation()] = 0;
                if (operation == 'W')
                {
                    if (pageTables[process, vpn].getDirtyBit() == 1)
                    {
                        dirtyWrites++;
                    }
                    else
                    {
                        pageTables[process, vpn].setDirtyBit(1);
                    }
                }
            }
        }
        Console.WriteLine("Algorithm: {0}\tPage Faults: {1}\tDisk References: {2}\tDirty Writes: {3}", 
                           algorithm, pageFaults, diskRef, dirtyWrites);
    }
}